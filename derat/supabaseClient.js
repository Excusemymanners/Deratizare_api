import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vfiarfondgufjckxewta.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmaWFyZm9uZGd1Zmpja3hld3RhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyNDk1MTgsImV4cCI6MjA4MDgyNTUxOH0.OZbnIDyQVGxsyKFtheN_NGLWp_EgHtLrHPWmLqp52_k';

const supabase = createClient(supabaseUrl, supabaseKey);

export default supabase;