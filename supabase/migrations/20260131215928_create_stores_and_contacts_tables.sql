/*
  # إنشاء جداول المتاجر والرسائل
  
  ## الجداول الجديدة
  
  ### جدول `stores` (المتاجر)
  - `id` (uuid, primary key) - معرف فريد للمتجر
  - `name` (text, required) - اسم المتجر
  - `url` (text, required) - رابط المتجر
  - `email` (text, required) - البريد الإلكتروني
  - `description` (text, required) - وصف المتجر
  - `status` (text, default 'pending') - حالة الموافقة (pending, approved, rejected)
  - `created_at` (timestamptz) - تاريخ الإنشاء
  
  ### جدول `contacts` (الرسائل)
  - `id` (uuid, primary key) - معرف فريد للرسالة
  - `name` (text, required) - اسم المرسل
  - `email` (text, required) - البريد الإلكتروني
  - `message` (text, required) - نص الرسالة
  - `created_at` (timestamptz) - تاريخ الإرسال
  
  ## الأمان
  - تفعيل RLS على كلا الجدولين
  - السماح للجميع بإدراج البيانات (للنماذج العامة)
  - السماح بقراءة المتاجر المعتمدة فقط
*/

-- إنشاء جدول المتاجر
CREATE TABLE IF NOT EXISTS stores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  url text NOT NULL,
  email text NOT NULL,
  description text NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- إنشاء جدول الرسائل
CREATE TABLE IF NOT EXISTS contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  message text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- تفعيل RLS على جدول المتاجر
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- سياسة للسماح للجميع بإضافة متجر جديد
CREATE POLICY "Anyone can insert stores"
  ON stores
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- سياسة للسماح بقراءة المتاجر المعتمدة فقط
CREATE POLICY "Anyone can read approved stores"
  ON stores
  FOR SELECT
  TO anon
  USING (status = 'approved');

-- تفعيل RLS على جدول الرسائل
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- سياسة للسماح للجميع بإرسال رسالة
CREATE POLICY "Anyone can insert contacts"
  ON contacts
  FOR INSERT
  TO anon
  WITH CHECK (true);