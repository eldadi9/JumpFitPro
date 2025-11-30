INSERT OR IGNORE INTO users (
  name, email, password_hash, role, is_active, 
  age, gender, height_cm, weight_kg, target_weight_kg,
  workouts_per_week, current_level, preferred_intensity,
  created_at
) VALUES (
  'אלדד גונשרוביץ',
  'eldadi9@gmail.com',
  'ZWxkYWQxMjM=',
  'admin',
  1,
  30,
  'male',
  175,
  80,
  70,
  5,
  'intermediate',
  'medium',
  datetime('now')
);
