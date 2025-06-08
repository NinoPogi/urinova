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

const Map<String, List<String>> personalizedRecos = {
  "Leukocytes": [
    "Normal hydration", // Negative (-)
    "Increase water intake slightly", // 15 ±
    "Monitor for infection", // 70+
    "Consult doctor for possible infection", // 125++
    "Seek medical attention if persistent" // 500+++
  ],
  "Nitrites": [
    "Maintain hygiene", // Negative (-)
    "Increase hydration, consult doctor" // Positive (+)
  ],
  "Urobilinogen": [
    "Balanced diet", // 0 (3.5)
    "Maintain hydration", // 1 (17)
    "Monitor liver function", // 2 (35)
    "Increase hydration, consult doctor", // 4 (70)
    "Liver evaluation recommended", // 8 (140)
    "Seek urgent liver assessment" // 12 (200)
  ],
  "Protein": [
    "No action needed", // Negative (-)
    "Reduce sodium intake", // 15 (0.15)
    "Monitor diet and hydration", // 30 (0.3)+
    "Consult doctor for kidney check", // 100 (1.0)++
    "Seek medical advice soon", // 300 (3.0)+++
    "Urgent kidney evaluation" // 2000 (20)+++
  ],
  "pH": [
    "Adjust to acidic foods if needed", // 5.0
    "Maintain balanced diet", // 6.0
    "No change needed", // 6.5
    "Balanced diet", // 7.0
    "Monitor hydration", // 7.5
    "Increase water, adjust diet", // 8.0
    "Consult doctor for alkalinity" // 9.0
  ],
  "Blood": [
    "Normal diet", // Negative (-)
    "Hydrate and rest", // ±
    "Monitor closely", // +
    "Consult doctor", // ++
    "Seek medical advice", // +++
    "Urgent care if persistent", // 5-10 Ery/µL
    "Seek immediate attention" // 50 Ery/µL
  ],
  "Specific Gravity": [
    "Check hydration", // 1.000
    "Stay hydrated", // 1.005
    "Maintain hydration", // 1.010
    "No change needed", // 1.015
    "Monitor fluid intake", // 1.020
    "Avoid dehydration", // 1.025
    "Check kidney function" // 1.030
  ],
  "Ketones": [
    "No change needed", // Negative (-)
    "Increase water", // 5 (0.5)
    "Monitor carb intake", // 15 (1.5)
    "Increase carbs slightly", // 40 (4.0)
    "Adjust diet, consult doctor", // 80 (8.0)
    "Seek medical advice" // 160 (16)
  ],
  "Bilirubin": [
    "No change needed", // Negative (-)
    "Increase hydration", // 1 (17)+
    "Monitor liver health", // 2 (35)++
    "Seek liver evaluation" // 4 (70)+++
  ],
  "Glucose": [
    "Maintain balanced diet", // Negative (-)
    "Monitor sugar intake", // 100 (5)
    "Reduce carbs, exercise", // 250 (15)
    "Consult doctor", // 500 (30)
    "Seek medical advice", // 1000 (60)
    "Urgent care needed" // ≥2000 (110)
  ]
};

const Map<String, Map<String, String>> trendRecos = {
  "Leukocytes": {
    "increasing": "Possible infection risk, monitor closely",
    "decreasing": "Infection may be resolving, continue care",
    "stable": "No immediate concern, maintain hygiene"
  },
  "Nitrites": {
    "increasing": "Risk of infection, consult doctor",
    "decreasing": "Improvement noted, maintain hygiene",
    "stable": "Continue monitoring"
  },
  "Urobilinogen": {
    "increasing": "Monitor liver function closely",
    "decreasing": "Liver may be stabilizing, keep hydrated",
    "stable": "Maintain current lifestyle"
  },
  "Protein": {
    "increasing": "Possible kidney strain, consult doctor",
    "decreasing": "Kidney function improving, monitor diet",
    "stable": "No urgent action needed"
  },
  "pH": {
    "increasing": "Check for alkalinity issues",
    "decreasing": "Monitor for acidity, adjust diet",
    "stable": "Maintain current diet"
  },
  "Blood": {
    "increasing": "Risk of worsening, seek advice",
    "decreasing": "May be resolving, rest and hydrate",
    "stable": "Continue monitoring"
  },
  "Specific Gravity": {
    "increasing": "Risk of dehydration, hydrate more",
    "decreasing": "Hydration improving, maintain intake",
    "stable": "Hydration stable, no change"
  },
  "Ketones": {
    "increasing": "Risk of ketosis, increase carbs",
    "decreasing": "Ketosis reducing, monitor diet",
    "stable": "No immediate concern"
  },
  "Bilirubin": {
    "increasing": "Liver stress possible, consult doctor",
    "decreasing": "Liver improving, maintain hydration",
    "stable": "No urgent action"
  },
  "Glucose": {
    "increasing": "Risk of hyperglycemia, seek advice",
    "decreasing": "Glucose stabilizing, monitor diet",
    "stable": "Maintain current management"
  }
};

const Map<String, Map<String, String>> dietaryRecos = {
  "Leukocytes": {
    "increasing": "Increase water, consider cranberry juice",
    "decreasing": "Maintain hydration, balanced diet",
    "stable": "No specific changes needed"
  },
  "Nitrites": {
    "increasing": "Boost hydration, avoid sugary drinks",
    "decreasing": "Continue hydration, light diet",
    "stable": "Maintain balanced diet"
  },
  "Urobilinogen": {
    "increasing": "Add leafy greens, stay hydrated",
    "decreasing": "Maintain balanced diet, water",
    "stable": "No dietary adjustment"
  },
  "Protein": {
    "increasing": "Reduce sodium, lean proteins",
    "decreasing": "Low-sodium diet, hydrate",
    "stable": "Balanced diet sufficient"
  },
  "pH": {
    "increasing": "More citrus fruits if too alkaline",
    "decreasing": "Reduce acidic foods if needed",
    "stable": "Keep diet balanced"
  },
  "Blood": {
    "increasing": "Hydrate, avoid salty foods",
    "decreasing": "Light diet, plenty of water",
    "stable": "No specific changes"
  },
  "Specific Gravity": {
    "increasing": "Increase water intake",
    "decreasing": "Maintain fluid intake",
    "stable": "Hydration adequate"
  },
  "Ketones": {
    "increasing": "Add carbs like fruits, grains",
    "decreasing": "Balanced carbs, hydrate",
    "stable": "No dietary change"
  },
  "Bilirubin": {
    "increasing": "Hydrate, avoid fatty foods",
    "decreasing": "Light diet, stay hydrated",
    "stable": "Maintain current diet"
  },
  "Glucose": {
    "increasing": "Reduce sugars, complex carbs",
    "decreasing": "Low-sugar diet, monitor",
    "stable": "Balanced diet sufficient"
  }
};

const Map<String, int> biomarkerWeights = {
  "Leukocytes": 2,
  "Nitrites": 3,
  "Urobilinogen": 1,
  "Protein": 2,
  "pH": 1,
  "Blood": 3,
  "Specific Gravity": 1,
  "Ketones": 2,
  "Bilirubin": 2,
  "Glucose": 3
};
