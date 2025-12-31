-- יצירת משתמש אדמין עם סיסמה חדשה
-- מייל: eldadi9@gmail.com
-- סיסמה: admin123 (מוצפנת ב-Base64)

INSERT OR REPLACE INTO users (
  name, email, password_hash, role, is_active, 
  age, gender, height_cm, weight_kg, target_weight_kg,
  workouts_per_week, current_level, preferred_intensity,
  created_at
) VALUES (
  'אלדד גונשרוביץ',
  'eldadi9@gmail.com',
  'YWRtaW4xMjM=',  -- Base64 של "admin123"
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

-- הודעה
SELECT 'משתמש אדמין נוצר בהצלחה!' AS message;
SELECT 'מייל: eldadi9@gmail.com' AS email;
SELECT 'סיסמה: admin123' AS password;

-- ============================================
-- מידע על הסיסמה הקיימת:
-- ============================================
-- הסיסמה הנוכחית במערכת: "eldad123"
-- (מוצפנת ב-Base64: ZWxkYWQxMjM=)
-- 
-- אם אתה רוצה לשנות את הסיסמה ל-"admin123",
-- הרץ את הקובץ הזה. אחרת, השתמש בסיסמה הקיימת.

