# Knowledge Engineering Report

## DCIT 313: Group LogicLab – Medical Expert System

**Date:** March 2026

---

## 1. Introduction

This document describes the **Knowledge Engineering** process used to develop the Medical Expert System. Knowledge Engineering is the process of acquiring, structuring, and encoding human expertise into a form that a computer system can use for automated reasoning.

Our system is designed to function as an **Intelligent Agent** that maps **perceptions** (user-reported symptoms) to **actions** (medical diagnoses and recommendations). The knowledge was encoded in **SWI-Prolog** as logical facts and rules, enabling the system's inference engine to reason symbolically.

---

## 2. Knowledge Acquisition

### 2.1 Domain Selection

We selected **Medical Diagnosis** as our domain because:
- It is a well-established area for expert systems (e.g., MYCIN, the pioneering medical expert system)
- It provides a clear mapping from symptoms (perceptions) to conditions (actions)
- It involves reasoning under uncertainty, which is a core AI concept
- It is relatable and easy to validate with common medical knowledge

### 2.2 Sources of Knowledge

The knowledge encoded in the system was acquired from the following sources:

| Source | Type | Usage |
|--------|------|-------|
| World Health Organization (WHO) | Authoritative medical reference | Symptom lists, condition classifications |
| Mayo Clinic (mayoclinic.org) | Medical knowledge base | Symptom-condition mappings, treatments |
| Centers for Disease Control (CDC) | Public health authority | COVID-19, Flu, Malaria, TB symptoms |
| Medical textbooks (Harrison's Principles of Internal Medicine) | Academic reference | Disease categorization (infection vs. chronic disease) |
| Ghana Health Service guidelines | National health authority | Local treatment recommendations |

### 2.3 Knowledge Elicitation Method

We employed the following knowledge elicitation techniques:
1. **Literature Review**: Studied medical references to identify symptoms, causes, and treatments
2. **Classification Analysis**: Categorized conditions into infections vs. chronic diseases
3. **Rule Extraction**: Translated medical decision trees into Prolog if-then rules
4. **Validation**: Cross-referenced symptoms across multiple sources to ensure accuracy

---

## 3. Knowledge Representation

### 3.1 Ontology Design

The knowledge is organized into the following categories:

```
Medical Knowledge
├── Conditions (8 conditions)
│   ├── Infections: flu, covid19, malaria, tuberculosis
│   └── Diseases: diabetes, hypertension, asthma, arthritis
├── Symptoms (28 unique symptoms)
│   └── Mapped to conditions via symptom(Condition, Symptom) facts
├── Causes
│   └── Mapped via caused_by(Condition, Cause) facts
├── Treatments
│   └── Mapped via treatment(Condition, Recommendation) facts
└── Risk Factors
    └── Mapped via risk_factor(Condition, Factor) facts
```

### 3.2 Prolog Representation

Knowledge is encoded using three primary Prolog constructs:

#### Facts (Ground Truths)
```prolog
% A condition and its category
condition(flu, infection).

% A symptom associated with a condition
symptom(flu, fever).
symptom(flu, cough).

% The cause of a condition
caused_by(flu, virus).

% Treatment recommendation
treatment(flu, 'Rest, stay hydrated, take fever reducers.').
```

#### Rules (Inference Logic)
```prolog
% A condition is diagnosed when all its symptoms match
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

#### Dynamic Assertions (Working Memory)
```prolog
:- dynamic(has_symptom/1).
:- dynamic(neg_symptom/1).
```

### 3.3 Mapping: Perceptions → Actions

| Stage | Component | Description |
|-------|-----------|-------------|
| **Perception** | Python Interface | Collects symptom inputs from the user |
| **Reasoning** | Prolog Inference Engine | Matches symptoms against rules to derive diagnoses |
| **Action** | Python Interface | Displays diagnosis, explanation, and recommendations |

---

## 4. System Architecture

### 4.1 Component Overview

1. **Knowledge Base** (`/knowledge_base/medical_expert_system.pl`):
   - Contains all facts (conditions, symptoms, causes, treatments, risk factors)
   - Contains inference rules (diagnosis logic, match scoring)
   - Acts as the system's **long-term memory**

2. **Inference Interface** (`/interface/main.py`):
   - Uses the `pyswip` library to bridge Python and SWI-Prolog
   - Handles user interaction (input/output)
   - Queries the Prolog engine and interprets results
   - Acts as the system's **sensors** (input) and **actuators** (output)

### 4.2 Inference Strategy

The system uses a combination of:
- **Backward Chaining**: Prolog's native resolution strategy, working from a goal (diagnosis) back to supporting evidence (symptoms)
- **Exhaustive Matching**: All conditions are evaluated, and a confidence score is calculated based on the percentage of matching symptoms
- **Ranked Output**: Conditions are sorted by match score, providing the user with the most likely diagnosis first

---

## 5. Conditions Covered

### 5.1 Infections

| Condition | Cause | Key Symptoms |
|-----------|-------|-------------|
| Flu | Virus | Fever, cough, headache, fatigue, sore throat |
| COVID-19 | Virus | Fever, cough, fatigue, loss of taste, difficulty breathing |
| Malaria | Parasite | Fever, chills, sweating, headache, nausea |
| Tuberculosis | Bacteria | Cough, chest pain, weight loss, night sweats |

### 5.2 Chronic Diseases

| Condition | Cause | Key Symptoms |
|-----------|-------|-------------|
| Diabetes | Metabolic disorder | Frequent urination, excessive thirst, fatigue, blurred vision |
| Hypertension | Cardiovascular disorder | Headache, dizziness, chest pain |
| Asthma | Inflammatory condition | Wheezing, shortness of breath, chest tightness, cough |
| Arthritis | Autoimmune condition | Joint pain, stiffness, swelling |

---

## 6. Testing and Validation

### 6.1 Positive Test Cases

| Test | Symptoms Provided | Expected Diagnosis | Result |
|------|------------------|-------------------|--------|
| T1 | fever, cough, headache, fatigue, sore throat | Flu (100%) | PASS |
| T2 | fever, cough, fatigue, loss of taste, difficulty breathing | COVID-19 (100%) | PASS |
| T3 | fever, chills, sweating, headache, nausea | Malaria (100%) | PASS |
| T4 | joint pain, stiffness, swelling | Arthritis (100%) | PASS |

### 6.2 Negative Test Cases

| Test | Symptoms Provided | Expected Result | Result |
|------|------------------|----------------|--------|
| N1 | No symptoms selected | No diagnosis | PASS |
| N2 | Only headache | Partial matches displayed | PASS |

### 6.3 Overlapping Symptom Test

| Test | Symptoms Provided | Expected Result | Result |
|------|------------------|----------------|--------|
| O1 | fever, cough, fatigue | Multiple matches: Flu, COVID-19 ranked | PASS |
| O2 | headache, chest pain | Multiple matches: Hypertension, Malaria ranked | PASS |

---

## 7. Limitations and Future Work

### Limitations
- The system only covers 8 medical conditions
- Diagnosis is based solely on symptom matching without considering severity, duration, or patient history
- No probabilistic reasoning (e.g., Bayesian networks) is used
- The system cannot handle symptoms not in its knowledge base

### Future Enhancements
- Add more conditions and symptoms to expand coverage
- Implement certainty factors or Bayesian reasoning for better confidence estimation
- Add patient history tracking across sessions
- Integrate with a graphical user interface (GUI) using Tkinter or Flask
- Incorporate natural language processing for free-text symptom input

---

## 8. References

1. World Health Organization. (2024). *International Classification of Diseases (ICD-11)*. https://www.who.int/
2. Mayo Clinic. (2024). *Diseases and Conditions*. https://www.mayoclinic.org/diseases-conditions
3. Centers for Disease Control and Prevention. (2024). *Disease Information*. https://www.cdc.gov/
4. Kasper, D. L., et al. (2018). *Harrison's Principles of Internal Medicine*. 20th ed. McGraw-Hill Education.
5. Ghana Health Service. (2024). *Standard Treatment Guidelines*. https://www.ghs.gov.gh/
6. Russell, S., & Norvig, P. (2020). *Artificial Intelligence: A Modern Approach*. 4th ed. Pearson.
7. Jackson, P. (1998). *Introduction to Expert Systems*. 3rd ed. Addison-Wesley.
