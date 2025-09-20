// Supabase Client Configuration
// Menggunakan konfigurasi dari environment.js

const SUPABASE_URL = window.SIHARAT_CONFIG?.supabase?.url || 'https://your-project-id.supabase.co'
const SUPABASE_ANON_KEY = window.SIHARAT_CONFIG?.supabase?.anonKey || 'your-anon-key-here'

// Supabase client instance
let supabase = null

// Initialize Supabase client
function initSupabase() {
    // Wait for environment config to load
    if (!window.SIHARAT_CONFIG) {
        console.warn('⚠️ Environment config not loaded yet, retrying...')
        setTimeout(initSupabase, 100)
        return false
    }
    
    if (typeof createClient !== 'undefined') {
        supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
        console.log('✅ Supabase client initialized with URL:', SUPABASE_URL)
        return true
    } else {
        console.error('❌ Supabase library not loaded. Please include the Supabase script.')
        return false
    }
}

// Test database connection
async function testConnection() {
    if (!supabase) {
        console.error('❌ Supabase not initialized')
        return false
    }

    try {
        const { data, error } = await supabase
            .from('employees')
            .select('count')
            .limit(1)
        
        if (error) {
            console.error('❌ Database query error:', error)
            throw error
        }
        console.log('✅ Database connection successful, data:', data)
        return true
    } catch (error) {
        console.error('❌ Database connection failed:', error)
        return false
    }
}

// Employee API functions
const employeeAPI = {
    // Get all employees
    async getAll() {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .select('*')
            .order('name')
        
        if (error) throw error
        return data
    },

    // Get employee by ID
    async getById(id) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .select('*')
            .eq('id', id)
            .single()
        
        if (error) throw error
        return data
    },

    // Create new employee
    async create(employeeData) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .insert(employeeData)
            .select()
        
        if (error) throw error
        return data[0]
    },

    // Update employee
    async update(id, employeeData) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .update(employeeData)
            .eq('id', id)
            .select()
        
        if (error) throw error
        return data[0]
    },

    // Delete employee
    async delete(id) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { error } = await supabase
            .from('employees')
            .delete()
            .eq('id', id)
        
        if (error) throw error
    },

    // Search employees
    async search(searchTerm) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .select('*')
            .or(`name.ilike.%${searchTerm}%,nip.ilike.%${searchTerm}%,position.ilike.%${searchTerm}%`)
            .order('name')
        
        if (error) throw error
        return data
    },

    // Filter by division
    async getByDivision(division) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .select('*')
            .eq('division', division)
            .order('name')
        
        if (error) throw error
        return data
    },

    // Filter by employee type
    async getByType(employeeType) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('employees')
            .select('*')
            .eq('employee_type', employeeType)
            .order('name')
        
        if (error) throw error
        return data
    }
}

// Meeting API functions
const meetingAPI = {
    // Get all meetings
    async getAll() {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('meetings')
            .select(`
                *,
                organizer:users(full_name)
            `)
            .order('meeting_date', { ascending: false })
        
        if (error) throw error
        return data
    },

    // Create new meeting
    async create(meetingData) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('meetings')
            .insert(meetingData)
            .select()
        
        if (error) throw error
        return data[0]
    },

    // Get meeting attendance
    async getAttendance(meetingId) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase
            .from('meeting_attendance')
            .select(`
                *,
                employee:employees(name, nip, position)
            `)
            .eq('meeting_id', meetingId)
        
        if (error) throw error
        return data
    }
}

// Authentication functions
const authAPI = {
    // Sign in
    async signIn(email, password) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data, error } = await supabase.auth.signInWithPassword({
            email: email,
            password: password
        })
        
        if (error) throw error
        return data
    },

    // Sign out
    async signOut() {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { error } = await supabase.auth.signOut()
        if (error) throw error
    },

    // Get current user
    async getCurrentUser() {
        if (!supabase) throw new Error('Supabase not initialized')
        
        const { data: { user } } = await supabase.auth.getUser()
        return user
    }
}

// Real-time subscription functions
const realtimeAPI = {
    // Subscribe to employees changes
    subscribeToEmployees(callback) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        return supabase
            .channel('employees_changes')
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: 'employees' },
                callback
            )
            .subscribe()
    },

    // Subscribe to meetings changes
    subscribeToMeetings(callback) {
        if (!supabase) throw new Error('Supabase not initialized')
        
        return supabase
            .channel('meetings_changes')
            .on('postgres_changes', 
                { event: '*', schema: 'public', table: 'meetings' },
                callback
            )
            .subscribe()
    }
}

// Export functions for global use
window.SupabaseAPI = {
    init: initSupabase,
    testConnection: testConnection,
    employee: employeeAPI,
    meeting: meetingAPI,
    auth: authAPI,
    realtime: realtimeAPI
}

// Auto-initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Wait for environment config to be available
    const checkConfig = setInterval(() => {
        if (window.SIHARAT_CONFIG) {
            clearInterval(checkConfig);
            
            // Load Supabase script if not already loaded
            if (typeof createClient === 'undefined') {
                const script = document.createElement('script')
                script.src = 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2'
                script.onload = function() {
                    initSupabase()
                }
                document.head.appendChild(script)
            } else {
                initSupabase()
            }
        }
    }, 100);
    
    // Timeout after 5 seconds
    setTimeout(() => {
        clearInterval(checkConfig);
        if (!window.SIHARAT_CONFIG) {
            console.error('❌ Environment config not loaded after 5 seconds');
        }
    }, 5000);
})
