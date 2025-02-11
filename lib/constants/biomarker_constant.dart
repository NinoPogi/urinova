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
