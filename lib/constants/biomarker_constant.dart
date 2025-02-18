const List<String> biomarkerNames = [
  "Specific Gravity",
  "pH",
  "Nitrites",
  "Ketones",
  "Bilirubin",
  "Urobilinogen",
  "Protein",
  "Glucose",
  "Blood",
  "Leukocytes"
];

const List<List<String>> biomarkerValues = [
  ["1.000", "1.005", "1.010", "1.015", "1.020", "1.025", "1.030"], // SG
  ["5.0", "6.0", "6.5", "7.0", "7.5", "8.0", "9.0"], // pH
  ["Negative (-)", "Positive (+)"], // Nitrites
  [
    "Negative (-)",
    "5 (0.5)",
    "15 (1.5)",
    "40 (4.0)",
    "80 (8.0)",
    "160 (16)"
  ], // Ketones
  ["Negative (-)", "1 (17)+", "2 (35)++", "4 (70)+++"], // Bilirubin
  [
    "0 (3.5)",
    "1 (17)",
    "2 (35)",
    "4 (70)",
    "8 (140)",
    "12 (200)"
  ], // Urobilinogen
  [
    "Negative (-)",
    "15 (0.15)",
    "30 (0.3)+",
    "100 (1.0)++",
    "300 (3.0)+++",
    "2000 (20)+++"
  ], // Protein
  [
    "Negative (-)",
    "100 (5)",
    "250 (15)",
    "500 (30)",
    "1000 (60)",
    "≥2000 (110)"
  ], // Glucose
  ["Negative (-)", "±", "+", "++", "+++", "5-10 Ery/µL", "50 Ery/µL"], // Blood
  ["Negative (-)", "15 ±", "70+", "125++", "500+++"] // Leukocytes
];

const Map<String, Map<String, String>> recommendationTable = {
  "Glucose": {
    "1": "Maintain balanced diet",
    "2": "Reduce carbs, exercise",
    "3": "Consult doctor"
  },
  "Bilirubin": {
    "1": "No change",
    "2": "Increase water",
    "3": "Liver evaluation"
  },
  "Ketones": {"1": "No change", "2": "Drink water", "3": "Increase carbs"},
  "Specific Gravity": {
    "1": "Stay hydrated",
    "2": "Avoid dehydration",
    "3": "Check kidney function"
  },
  "Blood": {
    "1": "Normal diet",
    "2": "Hydrate, rest",
    "3": "Seek medical advice"
  },
  "pH": {
    "1": "Maintain balanced diet",
    "2": "Adjust to acidic foods",
    "3": "Consult doctor"
  },
  "Protein": {"1": "No action", "2": "Reduce sodium", "3": "Consult doctor"},
  "Urobilinogen": {
    "1": "Balanced diet",
    "2": "Increase hydration",
    "3": "Liver evaluation"
  },
  "Nitrites": {
    "1": "Maintain hygiene",
    "2": "Increase water",
    "3": "Seek medical attention"
  },
  "Leukocytes": {
    "1": "Normal hydration",
    "2": "Increase water",
    "3": "Test for infection"
  }
};
