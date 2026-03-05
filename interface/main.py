"""
MEDICAL EXPERT SYSTEM - Python Interface
DCIT 313: Group LogicLab
Bridge between User and Prolog Knowledge Base using pyswip.
"""

import os
import sys
from pyswip import Prolog


def get_kb_path():
    """Resolve the path to the Prolog knowledge base file."""
    # Navigate from /interface to /knowledge_base
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    kb_path = os.path.join(base_dir, "knowledge_base", "medical_expert_system.pl")
    if not os.path.exists(kb_path):
        print(f"[ERROR] Knowledge base not found at: {kb_path}")
        sys.exit(1)
    return kb_path


def init_prolog():
    """Initialize the Prolog engine and load the knowledge base."""
    prolog = Prolog()
    kb_path = get_kb_path()
    prolog.consult(kb_path)
    print("[INFO] Knowledge base loaded successfully.\n")
    return prolog


# ──────────────────────────────────────────────
#  Helper: Query the Prolog KB
# ──────────────────────────────────────────────

def get_all_conditions(prolog):
    """Retrieve all conditions from the knowledge base."""
    results = list(prolog.query("condition(C, T)"))
    return [(r["C"], r["T"]) for r in results]


def get_symptoms_for(prolog, condition):
    """Retrieve all symptoms for a given condition."""
    results = list(prolog.query(f"symptom({condition}, S)"))
    return [r["S"] for r in results]


def get_cause(prolog, condition):
    """Retrieve the cause of a condition."""
    results = list(prolog.query(f"caused_by({condition}, Cause)"))
    return results[0]["Cause"] if results else "Unknown"


def get_treatment(prolog, condition):
    """Retrieve recommended treatment for a condition."""
    results = list(prolog.query(f"treatment({condition}, T)"))
    return results[0]["T"] if results else "No recommendation available."


def get_risk_factors(prolog, condition):
    """Retrieve risk factors for a condition."""
    results = list(prolog.query(f"risk_factor({condition}, F)"))
    return [r["F"] for r in results]


# ──────────────────────────────────────────────
#  Core: Symptom-Based Diagnosis (Inference)
# ──────────────────────────────────────────────

def collect_user_symptoms(prolog):
    """
    Present all unique symptoms to the user and collect yes/no answers.
    This maps Perceptions (user inputs) → stored facts for inference.
    """
    # Gather all unique symptoms from the KB
    results = list(prolog.query("symptom(_, S)"))
    all_symptoms = sorted(set(r["S"] for r in results))

    print("Please answer 'yes' or 'no' for each symptom:\n")

    confirmed = []
    for symptom in all_symptoms:
        while True:
            answer = input(f"  Do you have {symptom.replace('_', ' ')}? (yes/no): ").strip().lower()
            if answer in ("yes", "y"):
                confirmed.append(symptom)
                # Assert the symptom into Prolog's working memory
                prolog.assertz(f"has_symptom({symptom})")
                break
            elif answer in ("no", "n"):
                prolog.assertz(f"neg_symptom({symptom})")
                break
            else:
                print("    Please enter 'yes' or 'no'.")

    return confirmed


def run_diagnosis(prolog, confirmed_symptoms):
    """
    Use Prolog's inference engine to determine the best matching condition.
    Computes a match score for each condition and ranks them.
    """
    conditions = get_all_conditions(prolog)
    scored = []

    for condition, ctype in conditions:
        results = list(prolog.query(
            f"match_score({condition}, Score, Matched, Total)"
        ))
        if results:
            score = results[0]["Score"]
            matched = results[0]["Matched"]
            total = results[0]["Total"]
            if matched > 0:
                scored.append((condition, ctype, score, matched, total))

    # Sort by score descending
    scored.sort(key=lambda x: x[2], reverse=True)
    return scored


# ──────────────────────────────────────────────
#  Display: Results and Explanations
# ──────────────────────────────────────────────

def display_results(prolog, ranked_conditions, confirmed_symptoms):
    """Display diagnosis results with explanations."""
    print("\n" + "=" * 55)
    print("            DIAGNOSIS RESULTS")
    print("=" * 55)

    if not ranked_conditions:
        print("\nThe system could not match your symptoms to any known condition.")
        print("Please consult a healthcare professional for proper evaluation.")
        return

    # Show top diagnosis
    top = ranked_conditions[0]
    condition, ctype, score, matched, total = top

    print(f"\n  Most Likely Condition:  {condition.upper().replace('_', ' ')}")
    print(f"  Category:              {ctype}")
    print(f"  Confidence:            {score:.1f}% ({matched}/{total} symptoms matched)")
    print(f"  Cause:                 {get_cause(prolog, condition)}")

    # Explanation of the condition type
    print()
    if ctype == "infection":
        print("  [Explanation] This condition is caused by microorganisms")
        print("  such as bacteria, viruses, fungi, or parasites.")
    else:
        print("  [Explanation] This condition is not caused by microorganisms")
        print("  but by genetic, metabolic, or chronic factors.")

    # Treatment recommendation
    treatment = get_treatment(prolog, condition)
    print(f"\n  Recommended Action:\n  {treatment}")

    # Risk factors
    risks = get_risk_factors(prolog, condition)
    if risks:
        print("\n  Risk Factors:")
        for r in risks:
            print(f"    - {r}")

    # Show other possible conditions if any
    if len(ranked_conditions) > 1:
        print("\n" + "-" * 55)
        print("  Other Possible Conditions:")
        print("-" * 55)
        for condition, ctype, score, matched, total in ranked_conditions[1:]:
            print(f"    {condition.replace('_', ' '):20s} | {score:5.1f}% match ({matched}/{total} symptoms)")

    print("\n" + "=" * 55)
    print("  DISCLAIMER: This system is for educational purposes only.")
    print("  Always consult a qualified healthcare professional.")
    print("=" * 55)


def display_knowledge_base(prolog):
    """Display the full knowledge base contents for browsing."""
    print("\n" + "=" * 55)
    print("         KNOWLEDGE BASE OVERVIEW")
    print("=" * 55)

    conditions = get_all_conditions(prolog)
    for condition, ctype in conditions:
        symptoms = get_symptoms_for(prolog, condition)
        cause = get_cause(prolog, condition)
        print(f"\n  {condition.upper().replace('_', ' ')} ({ctype})")
        print(f"    Cause: {cause}")
        print(f"    Symptoms: {', '.join(s.replace('_', ' ') for s in symptoms)}")

    print()


# ──────────────────────────────────────────────
#  Main Application Loop
# ──────────────────────────────────────────────

def reset_working_memory(prolog):
    """Clear all asserted symptoms from Prolog's working memory."""
    list(prolog.query("retractall(has_symptom(_))"))
    list(prolog.query("retractall(neg_symptom(_))"))


def main():
    """Main entry point for the Medical Expert System."""
    print("=" * 55)
    print("      MEDICAL EXPERT SYSTEM")
    print("      Group LogicLab - DCIT 313")
    print("=" * 55)
    print("  A Knowledge-Based System for Medical Diagnosis")
    print("  Logic Engine: SWI-Prolog | Interface: Python")
    print("=" * 55)

    prolog = init_prolog()

    while True:
        print("\n  MAIN MENU")
        print("  ---------")
        print("  1. Start Diagnosis")
        print("  2. View Knowledge Base")
        print("  3. Exit")

        choice = input("\n  Select an option (1-3): ").strip()

        if choice == "1":
            # Reset working memory for a fresh consultation
            reset_working_memory(prolog)

            print("\n" + "-" * 55)
            print("  SYMPTOM ASSESSMENT")
            print("-" * 55)

            # Perception Phase: Collect symptoms from user
            confirmed = collect_user_symptoms(prolog)

            if not confirmed:
                print("\nNo symptoms were reported. Cannot perform diagnosis.")
                continue

            print(f"\nYou reported {len(confirmed)} symptom(s): "
                  f"{', '.join(s.replace('_', ' ') for s in confirmed)}")

            # Action Phase: Run inference and display results
            ranked = run_diagnosis(prolog, confirmed)
            display_results(prolog, ranked, confirmed)

        elif choice == "2":
            display_knowledge_base(prolog)

        elif choice == "3":
            print("\nThank you for using the Medical Expert System. Stay healthy!")
            break

        else:
            print("  Invalid option. Please enter 1, 2, or 3.")


if __name__ == "__main__":
    main()
