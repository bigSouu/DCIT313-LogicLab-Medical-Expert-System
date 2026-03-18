# How the Medical Expert System Works

This document explains in simple, direct steps how the Medical Expert System operates, specifically detailing how the Python interface communicates with the Prolog knowledge base to diagnose a user's symptoms.

## 1. System Components
The system is divided into two main parts:
- **Prolog (`knowledge_base/medical_expert_system.pl`)**: Serves as the "Brain" or Knowledge Base (KB). It contains all the medical facts (conditions, symptoms, causes, treatments) and the logical rules required to match symptoms to conditions.
- **Python (`interface/main.py`)**: Serves as the User Interface (UI) and Controller. It handles user interactions, sends the user's answers to Prolog, and formats the output diagnosis into a readable format.

## 2. Step-by-Step Execution Flow

### Step 1: Initialization
1. You run the `main.py` Python script.
2. Python uses a library called `pyswip` to initialize a background SWI-Prolog instance.
3. Python loads (consults) the Prolog knowledge base (`medical_expert_system.pl`) into this instance.

### Step 2: Gathering Symptoms
1. From the main menu, the user selects "Start Diagnosis".
2. Python queries Prolog for a list of *all* possible symptoms from all conditions (`symptom(_, S)`).
3. Python loops through these symptoms and asks the user: "Do you have [symptom]?" (`yes` or `no`).

### Step 3: Storing User Answers (Dynamic Memory)
1. If the user answers `yes`, Python tells Prolog to remember this fact by asserting it into Prolog's dynamic memory: `has_symptom(symptom)`.
2. If the user answers `no`, Python tells Prolog: `neg_symptom(symptom)`.
3. This creates a temporary working memory within Prolog representing the patient's current state.

### Step 4: Rule-Based Logic Processing (Diagnosis)
1. Python fetches all known conditions from Prolog.
2. For each condition, Python triggers a specific Prolog rule called `match_score`.
3. The `match_score` rule acts as the core logic engine:
   - It counts the total symptoms associated with that specific condition.
   - It checks the working memory to see how many of those symptoms the user actually has (`has_symptom/1`).
   - It calculates a percentage match score.
4. Python receives these match scores back from Prolog and ranks the conditions from highest to lowest probability.

### Step 5: Returning and Displaying the Result
1. Python isolates the top-ranked condition (highest percentage match).
2. Python issues a few more queries to Prolog to get specific details about that top condition, such as:
   - What is the cause? (`caused_by`)
   - What is the treatment? (`treatment`)
   - What are the risk factors? (`risk_factor`)
3. Finally, Python takes all this raw data provided by Prolog and prints a beautifully formatted, easy-to-read "Diagnosis Results" screen for the user.
4. Once the session is over or a new diagnosis is started, Python commands Prolog to wipe the temporary working memory (`retractall`) so a new patient can be assessed.

## Summary
In short: **Python asks the questions and formats the answers, while Prolog does the heavy lifting of remembering facts and applying logical rules to calculate the diagnosis.**
