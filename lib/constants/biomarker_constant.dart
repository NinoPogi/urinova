const List<String> biomarkerNames = [
  "Leukocytes",
  "Nitrites",
  "Urobilinogen",
  "Protein",
  "pH",
  "Blood",
  "Specific Gravity",
  "Ketones",
  "Bilirubin",
  "Glucose",
];

const List<List<String>> biomarkerValues = [
  ["Negative (-)", "15 ±", "70+", "125++", "500+++"], // Leukocytes
  ["Negative (-)", "Positive (+)"], // Nitrites
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
  ["5.0", "6.0", "6.5", "7.0", "7.5", "8.0", "9.0"], // pH
  ["Negative (-)", "±", "+", "++", "+++", "5-10 Ery/µL", "50 Ery/µL"], // Blood
  [
    "1.000",
    "1.005",
    "1.010",
    "1.015",
    "1.020",
    "1.025",
    "1.030"
  ], // Specific Gravity
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
    "Negative (-)",
    "100 (5)",
    "250 (15)",
    "500 (30)",
    "1000 (60)",
    "≥2000 (110)"
  ], // Glucose
];
