% ============================================================
%  MEDICAL EXPERT SYSTEM - Knowledge Base
%  DCIT 313: Group LogicLab
%  A Knowledge-Based System (KBS) for Medical Diagnosis
%  Logic Engine: SWI-Prolog
% ============================================================

% Dynamic Symptom Storage
:- dynamic(has_symptom/1).
:- dynamic(neg_symptom/1).

% ============================================================
%  FACTS: Conditions and their categories
% ============================================================

% condition(Name, Type)
condition(flu, infection).
condition(covid19, infection).
condition(malaria, infection).
condition(tuberculosis, infection).
condition(diabetes, disease).
condition(hypertension, disease).
condition(asthma, disease).
condition(arthritis, disease).

% ============================================================
%  FACTS: Causes of conditions
% ============================================================

% caused_by(Condition, Cause)
caused_by(flu, virus).
caused_by(covid19, virus).
caused_by(malaria, parasite).
caused_by(tuberculosis, bacteria).
caused_by(diabetes, metabolic_disorder).
caused_by(hypertension, cardiovascular_disorder).
caused_by(asthma, inflammatory_condition).
caused_by(arthritis, autoimmune_condition).

% ============================================================
%  FACTS: Symptoms associated with each condition
% ============================================================

% symptom(Condition, SymptomName)

% --- Flu ---
symptom(flu, fever).
symptom(flu, cough).
symptom(flu, headache).
symptom(flu, fatigue).
symptom(flu, sore_throat).

% --- COVID-19 ---
symptom(covid19, fever).
symptom(covid19, cough).
symptom(covid19, fatigue).
symptom(covid19, loss_of_taste).
symptom(covid19, difficulty_breathing).

% --- Malaria ---
symptom(malaria, fever).
symptom(malaria, chills).
symptom(malaria, sweating).
symptom(malaria, headache).
symptom(malaria, nausea).

% --- Tuberculosis ---
symptom(tuberculosis, cough).
symptom(tuberculosis, chest_pain).
symptom(tuberculosis, weight_loss).
symptom(tuberculosis, night_sweats).

% --- Diabetes ---
symptom(diabetes, frequent_urination).
symptom(diabetes, excessive_thirst).
symptom(diabetes, fatigue).
symptom(diabetes, blurred_vision).

% --- Hypertension ---
symptom(hypertension, headache).
symptom(hypertension, dizziness).
symptom(hypertension, chest_pain).

% --- Asthma ---
symptom(asthma, wheezing).
symptom(asthma, shortness_of_breath).
symptom(asthma, chest_tightness).
symptom(asthma, cough).

% --- Arthritis ---
symptom(arthritis, joint_pain).
symptom(arthritis, stiffness).
symptom(arthritis, swelling).

% ============================================================
%  FACTS: Treatment recommendations
% ============================================================

% treatment(Condition, Recommendation)
treatment(flu, 'Rest, stay hydrated, take over-the-counter fever reducers (e.g., paracetamol). See a doctor if symptoms worsen.').
treatment(covid19, 'Self-isolate, monitor oxygen levels, stay hydrated, and seek immediate medical attention if breathing becomes difficult.').
treatment(malaria, 'Seek medical attention immediately. Antimalarial drugs (e.g., ACTs) are the standard treatment. Do not self-medicate.').
treatment(tuberculosis, 'Requires a long course of antibiotics (6-9 months). Visit a healthcare facility for proper diagnosis and DOTS therapy.').
treatment(diabetes, 'Monitor blood sugar levels regularly, follow a balanced diet, exercise, and consult an endocrinologist for medication.').
treatment(hypertension, 'Reduce salt intake, exercise regularly, manage stress, and consult a doctor for antihypertensive medication.').
treatment(asthma, 'Use prescribed inhalers (bronchodilators), avoid known triggers, and have an asthma action plan from your doctor.').
treatment(arthritis, 'Stay physically active, apply warm/cold compresses, and consult a rheumatologist for anti-inflammatory medication.').

% ============================================================
%  FACTS: Risk factors
% ============================================================

% risk_factor(Condition, Factor)
risk_factor(flu, 'Close contact with infected individuals').
risk_factor(flu, 'Weak immune system').
risk_factor(covid19, 'Close contact without masks').
risk_factor(covid19, 'Crowded indoor environments').
risk_factor(malaria, 'Travel to endemic regions').
risk_factor(malaria, 'Lack of mosquito nets').
risk_factor(tuberculosis, 'HIV/AIDS co-infection').
risk_factor(tuberculosis, 'Overcrowded living conditions').
risk_factor(diabetes, 'Family history of diabetes').
risk_factor(diabetes, 'Obesity and sedentary lifestyle').
risk_factor(hypertension, 'High salt diet').
risk_factor(hypertension, 'Chronic stress').
risk_factor(asthma, 'Family history of asthma or allergies').
risk_factor(asthma, 'Exposure to air pollution').
risk_factor(arthritis, 'Age above 50').
risk_factor(arthritis, 'Family history of arthritis').

% ============================================================
%  RULES: Interactive Questioning System
% ============================================================

% If the user already confirmed a symptom, succeed immediately
ask(Symptom) :-
    has_symptom(Symptom), !.

% If the user already denied a symptom, fail immediately
ask(Symptom) :-
    neg_symptom(Symptom), !, fail.

% Otherwise, ask the user
ask(Symptom) :-
    format('Do you have ~w? (yes/no): ', [Symptom]),
    read(Response),
    ( Response == yes ->
        assertz(has_symptom(Symptom))
    ;
        assertz(neg_symptom(Symptom)),
        fail
    ).

% ============================================================
%  RULES: Diagnosis Logic (Inference Engine)
% ============================================================

% A condition is diagnosed if ALL its symptoms are confirmed
diagnose(Condition) :-
    condition(Condition, _),
    findall(S, symptom(Condition, S), Symptoms),
    check_all_symptoms(Symptoms).

% Check that all symptoms in the list are confirmed
check_all_symptoms([]).
check_all_symptoms([H|T]) :-
    ask(H),
    check_all_symptoms(T).

% Calculate a match percentage for partial matches
match_score(Condition, Score, Matched, Total) :-
    condition(Condition, _),
    findall(S, symptom(Condition, S), AllSymptoms),
    length(AllSymptoms, Total),
    Total > 0,
    include(has_symptom, AllSymptoms, MatchedSymptoms),
    length(MatchedSymptoms, Matched),
    Score is (Matched / Total) * 100.

% ============================================================
%  RULES: Explanation System
% ============================================================

explain_type(infection) :-
    write('This condition is caused by microorganisms such as bacteria, viruses, fungi, or parasites.'), nl.

explain_type(disease) :-
    write('This condition is not caused by microorganisms but by genetic, metabolic, or chronic factors.'), nl.

explain_cause(Condition) :-
    caused_by(Condition, Cause),
    format('Cause: ~w~n', [Cause]).

explain_treatment(Condition) :-
    treatment(Condition, Rec),
    format('Recommended Action: ~w~n', [Rec]).

explain_risks(Condition) :-
    write('Risk Factors:'), nl,
    forall(
        risk_factor(Condition, Factor),
        (write('  - '), write(Factor), nl)
    ).

% ============================================================
%  RULES: System Entry Point (for direct Prolog use)
% ============================================================

start :-
    retractall(has_symptom(_)),
    retractall(neg_symptom(_)),
    write('============================================'), nl,
    write('   MEDICAL EXPERT SYSTEM'), nl,
    write('   Group LogicLab - DCIT 313'), nl,
    write('============================================'), nl,
    write('Answer the following questions about your symptoms.'), nl, nl,
    ( diagnose(Condition) ->
        condition(Condition, Type),
        nl, write('============================================'), nl,
        write('DIAGNOSIS RESULT'), nl,
        write('============================================'), nl,
        format('Based on your symptoms, you may have: ~w~n', [Condition]),
        format('Category: ~w~n', [Type]),
        explain_cause(Condition),
        nl, explain_type(Type),
        nl, explain_treatment(Condition),
        nl, explain_risks(Condition),
        nl, write('DISCLAIMER: This is an expert system for educational purposes only.'), nl,
        write('Always consult a qualified healthcare professional for medical advice.'), nl
    ;
        nl, write('Sorry, the system could not determine a diagnosis based on your symptoms.'), nl,
        write('Please consult a healthcare professional for proper evaluation.'), nl
    ).

% Reset the system for a new consultation
reset :-
    retractall(has_symptom(_)),
    retractall(neg_symptom(_)),
    write('System has been reset. You may start a new consultation.'), nl.
