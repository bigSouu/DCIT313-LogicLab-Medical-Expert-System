# Knowledge Engineering Report

## DCIT 313: Group LogicLab - Medical Expert System

**Date:** March 2026

---

## 1. Introduction

This report documents how we went about building our Medical Expert System for DCIT 313. The main idea was to create a system that takes in symptoms from a user and gives back a possible diagnosis — essentially mapping what the user tells us (perceptions) to what the system concludes (actions).

We used SWI-Prolog to store all the medical knowledge as logical facts and rules, and Python (with pyswip) to handle the user interaction side.

---

## 2. Knowledge Acquisition

### 2.1 Why Medical Diagnosis?

We chose medical diagnosis as our domain for a few reasons:
- Expert systems have a long history in medicine (e.g., MYCIN), so there's a lot of precedent
- Symptoms map naturally to conditions, which fits well with Prolog's pattern matching
- It's easy to test — we can verify whether the right condition comes up for a given set of symptoms
- Everyone in the group has some familiarity with common illnesses

### 2.2 Where We Got Our Information

We gathered the medical knowledge from these sources:

| Source | What we used it for |
|--------|-------------------|
| WHO (who.int) | Symptom lists, how conditions are classified |
| Mayo Clinic (mayoclinic.org) | Matching symptoms to conditions, treatment info |
| CDC (cdc.gov) | Specifically for COVID-19, Flu, Malaria, and TB details |
| Harrison's Principles of Internal Medicine (textbook) | Categorizing conditions as infections vs. chronic diseases |
| Ghana Health Service guidelines | Treatment recommendations relevant to our context |

### 2.3 How We Did It

Our process was basically:
1. Read through medical sources and listed out symptoms, causes, and treatments for each condition
2. Grouped conditions into infections and chronic diseases
3. Converted the symptom-condition relationships into Prolog facts
4. Wrote the diagnosis rules to match symptoms against conditions
5. Tested with different symptom combinations to make sure it worked correctly

---

## 3. Knowledge Representation

### 3.1 How the KB is Organized

```
Medical Knowledge
├── Conditions (8 conditions)
│   ├── Infections: flu, covid19, malaria, tuberculosis
│   └── Diseases: diabetes, hypertension, asthma, arthritis
├── Symptoms (mapped to conditions)
├── Causes (what causes each condition)
├── Treatments (what to do for each condition)
└── Risk Factors (what makes someone more likely to get it)
```

### 3.2 How It Looks in Prolog

Knowledge is encoded using three types of Prolog constructs:

**Facts** (straightforward declarations):
```prolog
% A condition and its category
condition(flu, infection).

symptom(flu, fever).
symptom(flu, cough).

caused_by(flu, virus).
treatment(flu, 'Rest, stay hydrated, take fever reducers.').
```

**Rules** (define the diagnosis logic):
```prolog
% Diagnose a condition if all its symptoms match
diagnose(Condition) :-
    condition(Condition, _),
    findall(S, symptom(Condition, S), Symptoms),
    check_all_symptoms(Symptoms).

% Calculate a match percentage for partial matches
match_score(Condition, Score, Matched, Total) :-
    condition(Condition, _),
    findall(S, symptom(Condition, S), AllSymptoms),
    length(AllSymptoms, Total),
    Total > 0,
    include(has_symptom, AllSymptoms, MatchedSymptoms),
    length(MatchedSymptoms, Matched),
    Score is (Matched / Total) * 100.
```

**Dynamic predicates** (store user responses at runtime):
```prolog
:- dynamic(has_symptom/1).
:- dynamic(neg_symptom/1).
```

### 3.3 How Input Flows to Output

1. **Input:** Python interface asks user about symptoms
2. **Processing:** Symptoms get asserted into Prolog, which matches them against its rules
3. **Output:** Python reads back the diagnosis scores and shows results

---

## 4. System Architecture

The system has two main parts:

1. **Knowledge Base** (`knowledge_base/medical_expert_system.pl`) — all the Prolog facts and rules. This is essentially the "brain" of the system.

2. **Python Interface** (`interface/main.py`) — uses pyswip to load the Prolog file, collect user input, run queries, and display results. This is the part the user actually interacts with.

The inference strategy uses Prolog's built-in backward chaining. We also score all conditions by what percentage of their symptoms match, so even partial matches show up in the results (ranked by confidence).

---

## 5. Conditions Covered

### Infections

| Condition | Cause | Key Symptoms |
|-----------|-------|-------------|
| Flu | Virus | Fever, cough, headache, fatigue, sore throat |
| COVID-19 | Virus | Fever, cough, fatigue, loss of taste, difficulty breathing |
| Malaria | Parasite | Fever, chills, sweating, headache, nausea |
| Tuberculosis | Bacteria | Cough, chest pain, weight loss, night sweats |

### Chronic Diseases

| Condition | Cause | Key Symptoms |
|-----------|-------|-------------|
| Diabetes | Metabolic disorder | Frequent urination, excessive thirst, fatigue, blurred vision |
| Hypertension | Cardiovascular disorder | Headache, dizziness, chest pain |
| Asthma | Inflammatory condition | Wheezing, shortness of breath, chest tightness, cough |
| Arthritis | Autoimmune condition | Joint pain, stiffness, swelling |

---

## 6. Testing

We tested the system with a bunch of different scenarios:

**Full match tests** — giving all symptoms for a condition should return that condition at 100%:

| Symptoms given | Expected result | Passed? |
|---------------|----------------|----------|
| fever, cough, headache, fatigue, sore throat | Flu (100%) | Yes |
| fever, cough, fatigue, loss of taste, difficulty breathing | COVID-19 (100%) | Yes |
| fever, chills, sweating, headache, nausea | Malaria (100%) | Yes |
| joint pain, stiffness, swelling | Arthritis (100%) | Yes |

**No-symptom test** — selecting nothing should give no diagnosis: **Passed**

**Single symptom test** — just "headache" should show partial matches for Flu, Malaria, Hypertension: **Passed**

**Overlapping symptom tests:**
- fever + cough + fatigue → shows both Flu and COVID-19 as matches: **Passed**
- headache + chest pain → shows Hypertension, TB, and Malaria as partial matches: **Passed**

---

## 7. Limitations

- Only covers 8 conditions — a real system would need way more
- Doesn't consider how severe symptoms are, how long they've lasted, or patient history
- No probabilistic reasoning (like Bayesian networks)
- If you have a symptom that's not in the KB, the system just ignores it

In the future, we could add more conditions, use certainty factors for better scoring, or even build a GUI with something like Flask.

---

## 8. References

1. World Health Organization. (2024). *International Classification of Diseases (ICD-11)*. https://www.who.int/
2. Mayo Clinic. (2024). *Diseases and Conditions*. https://www.mayoclinic.org/diseases-conditions
3. Centers for Disease Control and Prevention. (2024). *Disease Information*. https://www.cdc.gov/
4. Kasper, D. L., et al. (2018). *Harrison's Principles of Internal Medicine*. 20th ed. McGraw-Hill.
5. Ghana Health Service. (2024). *Standard Treatment Guidelines*. https://www.ghs.gov.gh/
6. Russell, S., & Norvig, P. (2020). *Artificial Intelligence: A Modern Approach*. 4th ed. Pearson.
7. Jackson, P. (1998). *Introduction to Expert Systems*. 3rd ed. Addison-Wesley.
