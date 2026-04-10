-- Students table
CREATE TABLE IF NOT EXISTS public.students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  birth_date DATE,
  gender TEXT CHECK (gender IN ('masculino', 'feminino', 'outro')),
  height NUMERIC(5,2),
  initial_weight NUMERIC(5,2),
  goal TEXT,
  activity_level TEXT CHECK (activity_level IN ('sedentario', 'leve', 'moderado', 'intenso', 'muito_intenso')),
  notes TEXT,
  avatar_url TEXT,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
CREATE POLICY "students_select" ON public.students FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "students_insert" ON public.students FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "students_update" ON public.students FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "students_delete" ON public.students FOR DELETE USING (auth.uid() = user_id);

-- Physical assessments
CREATE TABLE IF NOT EXISTS public.assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  assessed_at DATE NOT NULL DEFAULT CURRENT_DATE,
  weight NUMERIC(5,2),
  body_fat_pct NUMERIC(4,2),
  muscle_mass_pct NUMERIC(4,2),
  chest_cm NUMERIC(5,1),
  waist_cm NUMERIC(5,1),
  hip_cm NUMERIC(5,1),
  arm_cm NUMERIC(5,1),
  thigh_cm NUMERIC(5,1),
  calf_cm NUMERIC(5,1),
  bmi NUMERIC(4,2),
  performance_score INTEGER CHECK (performance_score BETWEEN 0 AND 100),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.assessments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "assessments_select" ON public.assessments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "assessments_insert" ON public.assessments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "assessments_update" ON public.assessments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "assessments_delete" ON public.assessments FOR DELETE USING (auth.uid() = user_id);

-- Diet plans
CREATE TABLE IF NOT EXISTS public.diet_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL DEFAULT 'Plano Alimentar',
  total_calories INTEGER,
  protein_g INTEGER,
  carbs_g INTEGER,
  fat_g INTEGER,
  content JSONB,
  ai_generated BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.diet_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "diet_plans_select" ON public.diet_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "diet_plans_insert" ON public.diet_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "diet_plans_update" ON public.diet_plans FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "diet_plans_delete" ON public.diet_plans FOR DELETE USING (auth.uid() = user_id);

-- Training plans
CREATE TABLE IF NOT EXISTS public.training_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL DEFAULT 'Plano de Treino',
  frequency_days INTEGER DEFAULT 3,
  content JSONB,
  ai_generated BOOLEAN DEFAULT false,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.training_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "training_plans_select" ON public.training_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "training_plans_insert" ON public.training_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "training_plans_update" ON public.training_plans FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "training_plans_delete" ON public.training_plans FOR DELETE USING (auth.uid() = user_id);

-- Media gallery
CREATE TABLE IF NOT EXISTS public.media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  caption TEXT,
  media_type TEXT DEFAULT 'image',
  taken_at DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;
CREATE POLICY "media_select" ON public.media FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "media_insert" ON public.media FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "media_update" ON public.media FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "media_delete" ON public.media FOR DELETE USING (auth.uid() = user_id);

-- AI insights
CREATE TABLE IF NOT EXISTS public.ai_insights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.students(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('performance', 'diet', 'training', 'general')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.ai_insights ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ai_insights_select" ON public.ai_insights FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "ai_insights_insert" ON public.ai_insights FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "ai_insights_update" ON public.ai_insights FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "ai_insights_delete" ON public.ai_insights FOR DELETE USING (auth.uid() = user_id);
