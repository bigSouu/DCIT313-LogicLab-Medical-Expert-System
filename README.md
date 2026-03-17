# DCIT313-LogicLab-Medical-Expert-System

## DCIT 313: Group Project - Expert System

This is a medical expert system built with SWI-Prolog and Python. It takes in symptoms from the user and tries to figure out what condition they might have based on the rules in the knowledge base.

> **Note**: This is not based strictly on  medical knowledge.

---

## Group Members

| Name | Student ID | Role |
|------|-----------|------|
| Afatsawo Bright | 22183667 | Project Manager |
| Stephanie Apenteng | 22044374 | Knowledge Engineer |
| Yeboah Kelvin Kofi Breman | 22063527 | Prolog Developer |
| Precious Ayomah Asummasum | 22176813 | Programmer|
| Roselyn Sakyi | 22012206 | Knowledge Engineer |
| Somuah Anim Kofi | 22013390 | Python Interface Developer |
| Aaron Tetteh | 22059189 | Programmer |

---

## What It Does

The system currently handles 8 conditions:

- **Infections**: Flu, COVID-19, Malaria, Tuberculosis
- **Chronic conditions**: Diabetes, Hypertension, Asthma, Arthritis

When you run the program, it asks you about different symptoms (yes/no), then it checks those symptoms against the Prolog rules and tells you:
- Which condition is the best match (with a percentage)
- What type of condition it is and what causes it
- Recommended treatment
- Risk factors
- Any other conditions that partially matched

---

## Project Structure

```
knowledge_base/
    medical_expert_system.pl   -- Prolog rules and facts
interface/
    main.py                    -- Python script (uses pyswip)
docs/
    knowledge_engineering_report.md
requirements.txt
README.md
```

- `/knowledge_base` contains Prolog facts and rules (this is where the "intelligence" lives)
- `/interface` has the Python script that talks to the Prolog engine and handles user I/O
- `/docs` has the report on how we gathered and encoded the medical knowledge

---

## How to Run

### Prerequisites
- SWI-Prolog installed (`brew install swi-prolog` on Mac)
- Python 3.8+

### Setup
```bash
git clone https://github.com/bigSouu/DCIT313-LogicLab-Medical-Expert-System.git
cd DCIT313-LogicLab-Medical-Expert-System

pip install -r requirements.txt

python interface/main.py
```

### Usage
1. Pick "Start Diagnosis" from the menu
2. Answer yes or no for each symptom
3. View the results
4. You can also pick "View Knowledge Base" to see all the conditions and symptoms the system knows about

---

## How It Works

The Python script (main.py) acts as the front-end. It collects symptoms from the user and sends queries to the Prolog engine through pyswip. The Prolog file has all the medical knowledge stored as facts (like which symptoms go with which condition) and rules (like how to calculate a match score). Prolog does the actual reasoning/inference, and Python just displays the results.

Basically:
1. User inputs symptoms, Python asserts them into Prolog working memory
2. Prolog computes match scores for each condition
3. Python reads the scores back and displays them ranked

---

## License

Academic project for DCIT 313, University of Ghana.
