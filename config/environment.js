// ========================================
// SI-HARAT Environment Configuration
// ========================================

const config = {
    // Supabase Configuration
    supabase: {
        url: 'https://msqqqkmcvnltvfcgtrhy.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zcXFxa21jdm5sdHZmY2d0cmh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyOTM1NTQsImV4cCI6MjA3Mzg2OTU1NH0.E6C7TCCac4OF_t5IDB4NAqF0LO-AssZEJEs5Mll5Hx4',
        serviceRoleKey: 'your-service-role-key-here'
    },

    // Application Configuration
    app: {
        name: 'SI-HARAT',
        version: '1.0.0',
        environment: 'development'
    },

    // API Configuration
    api: {
        baseUrl: 'https://your-project.supabase.co',
        timeout: 30000
    },

    // Authentication Configuration
    auth: {
        redirectUrl: window.location.origin + '/dashboard',
        sessionDuration: 3600 // 1 hour
    },

    // File Upload Configuration
    upload: {
        maxFileSize: 10485760, // 10MB
        allowedTypes: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png']
    },

    // Notification Configuration
    notifications: {
        enabled: true,
        sound: true
    },

    // Development Configuration
    debug: {
        enabled: true,
        logLevel: 'debug'
    }
}

// Environment-specific overrides
if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    // Development environment
    config.app.environment = 'development'
    config.debug.enabled = true
} else {
    // Production environment
    config.app.environment = 'production'
    config.debug.enabled = false
    config.debug.logLevel = 'error'
}

// Export configuration
window.SIHARAT_CONFIG = config

// Log configuration (only in development)
if (config.debug.enabled) {
    console.log('🔧 SI-HARAT Configuration loaded:', config)
}
