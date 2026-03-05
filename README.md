# DCIT313-GroupLogicLab-Medical-Expert-System

## DCIT 313: Group Project – Knowledge-Based Expert System

A **Knowledge-Based System (KBS)** that functions as an **Intelligent Agent** for medical diagnosis. The system maps **perceptions** (user-reported symptoms) to **actions** (diagnosis, explanations, and treatment recommendations) using symbolic AI and logical inference.

---

## Group Members

| Name | Student ID | Role |
|------|-----------|------|
| Afatsawo Bright | 22183667 | Knowledge Engineer |
| Stephanie Apenteng | 22044374 | Knowledge Engineer |
| Yeboah Kelvin Kofi Breman | 22063527 | Prolog Developer |
| Precious Ayomah Asummasum | 22176813 | Prolog Developer |
| Roselyn Sakyi | 22012206 | Python Interface Developer |
| Somuah Anim Kofi | 22013390 | Python Interface Developer |
| Aaron Tetteh | 22059189 | Documentation & Testing |

---

## System Purpose

This Medical Expert System assists users in identifying potential medical conditions based on their reported symptoms. It covers 8 conditions across two categories:

- **Infections**: Flu, COVID-19, Malaria, Tuberculosis
- **Chronic Diseases**: Diabetes, Hypertension, Asthma, Arthritis

The system uses **forward chaining** and **pattern matching** through SWI-Prolog's inference engine to reason over a knowledge base of medical facts and rules, providing:
- A ranked list of possible diagnoses with confidence scores
- Explanations of the condition type and cause
- Treatment recommendations
- Associated risk factors

> **Disclaimer**: This system is for educational purposes only and should not replace professional medical advice.

---

## Technical Stack

| Component | Technology |
|-----------|------------|
| Logic Engine | SWI-Prolog |
| User Interface | Python 3 + pyswip |
| Version Control | GitHub |

---

## Project Structure

```
DCIT313-GroupLogicLab-Medical-Expert-System/
├── knowledge_base/
│   └── medical_expert_system.pl    # Prolog facts & rules (KB)
├── interface/
│   └── main.py                     # Python UI using pyswip
├── docs/
│   └── knowledge_engineering_report.md  # Knowledge acquisition report
├── requirements.txt                # Python dependencies
├── .gitignore
└── README.md                       # This file
```

| Directory | Purpose | AI Role |
|-----------|---------|---------|
| `/knowledge_base` | Prolog `.pl` file with logical Facts and Rules | Memory/Intelligence |
| `/interface` | Python script that queries the Prolog engine | User Interaction |
| `/docs` | Knowledge Engineering report and documentation | Knowledge Acquisition |

---

## Prerequisites

1. **SWI-Prolog** must be installed on your system:
   - macOS: `brew install swi-prolog`
   - Ubuntu/Debian: `sudo apt-get install swi-prolog`
   - Windows: Download from [swi-prolog.org](https://www.swi-prolog.org/download/stable)

2. **Python 3.8+** must be installed.

---

## Installation & Setup

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/DCIT313-GroupLogicLab-Medical-Expert-System.git
cd DCIT313-GroupLogicLab-Medical-Expert-System

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Run the Expert System
python interface/main.py
```

---

## How to Use

1. Run the system with `python interface/main.py`
2. Select **"1. Start Diagnosis"** from the main menu
3. Answer `yes` or `no` for each symptom the system asks about
4. View the diagnosis results, including:
   - Most likely condition and confidence score
   - Condition category and cause
   - Treatment recommendations
   - Risk factors
   - Other possible conditions
5. Select **"2. View Knowledge Base"** to browse all conditions and symptoms

---

## How It Works (Agent Architecture)

```
┌──────────────────────────────────────────────────┐
│                  ENVIRONMENT                      │
│            (User with symptoms)                   │
└──────────────┬───────────────────▲────────────────┘
               │ Perceptions       │ Actions
               │ (Symptoms)        │ (Diagnosis)
               ▼                   │
┌──────────────────────────────────────────────────┐
│              INTELLIGENT AGENT                    │
│  ┌─────────────────────────────────────────────┐  │
│  │  Python Interface (interface/main.py)       │  │
│  │  - Collects user symptoms (Sensors)         │  │
│  │  - Displays results (Actuators)             │  │
│  └──────────────┬──────────────▲───────────────┘  │
│                 │ Queries      │ Results           │
│                 ▼              │                   │
│  ┌─────────────────────────────────────────────┐  │
│  │  SWI-Prolog Engine (knowledge_base/*.pl)    │  │
│  │  - Facts: conditions, symptoms, causes      │  │
│  │  - Rules: diagnosis logic, match scoring    │  │
│  │  - Inference: pattern matching & reasoning  │  │
│  └─────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

---

## License

This project is developed for academic purposes as part of the DCIT 313 course at the University of Ghana.
