// Load environment configuration
const supabaseConfig = window.SIHARAT_CONFIG || {
    supabase: {
        url: 'https://msqqqkmcvnltvfcgtrhy.supabase.co',
        anonKey: 'yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zcXFxa21jdm5sdHZmY2d0cmh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyOTM1NTQsImV4cCI6MjA3Mzg2OTU1NH0.E6C7TCCac4OF_t5IDB4NAqF0LO-AssZEJEs5Mll5Hx4'
    }
};

// Initialize Supabase client
const supabase = window.supabase.createClient(supabaseConfig.supabase.url, supabaseConfig.supabase.anonKey);

// Electricity Management API Functions
class ElectricityAPI {
    constructor() {
        this.supabase = supabase;
    }

    // Get all buildings
    async getBuildings() {
        try {
            const { data, error } = await this.supabase
                .from('buildings')
                .select('*')
                .order('name');
            
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching buildings:', error);
            throw error;
        }
    }

    // Get electricity readings
    async getElectricityReadings(limit = 10) {
        try {
            const { data, error } = await this.supabase
                .from('electricity_management')
                .select(`
                    *,
                    buildings(name, location),
                    users(name)
                `)
                .order('reading_date', { ascending: false })
                .limit(limit);
            
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching electricity readings:', error);
            throw error;
        }
    }

    // Add new electricity reading
    async addElectricityReading(readingData) {
        try {
            const { data, error } = await this.supabase
                .from('electricity_management')
                .insert([readingData])
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error adding electricity reading:', error);
            throw error;
        }
    }

    // Update electricity reading
    async updateElectricityReading(id, readingData) {
        try {
            const { data, error } = await this.supabase
                .from('electricity_management')
                .update(readingData)
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error updating electricity reading:', error);
            throw error;
        }
    }

    // Delete electricity reading
    async deleteElectricityReading(id) {
        try {
            const { data, error } = await this.supabase
                .from('electricity_management')
                .delete()
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error deleting electricity reading:', error);
            throw error;
        }
    }

    // Get electricity consumption summary
    async getConsumptionSummary() {
        try {
            const { data, error } = await this.supabase
                .from('electricity_consumption_summary')
                .select('*');
            
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching consumption summary:', error);
            throw error;
        }
    }

    // Get electricity bills
    async getElectricityBills(limit = 10) {
        try {
            const { data, error } = await this.supabase
                .from('electricity_bills')
                .select(`
                    *,
                    buildings(name, location)
                `)
                .order('bill_date', { ascending: false })
                .limit(limit);
            
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching electricity bills:', error);
            throw error;
        }
    }

    // Token Management Functions (sesuai dengan tabel log_pengisian_token)
    
    // Get token purchase logs
    async getTokenPurchaseLogs(limit = 10) {
        try {
            const { data, error } = await this.supabase
                .from('log_pengisian_token')
                .select('*')
                .order('created_at', { ascending: false })
                .limit(limit);
            
            if (error) {
                console.error('Supabase error:', error);
                // Return empty array if table doesn't exist
                if (error.code === 'PGRST116' || error.message.includes('relation "log_pengisian_token" does not exist')) {
                    console.warn('Table log_pengisian_token does not exist, returning empty array');
                    return [];
                }
                throw error;
            }
            
            // Add petugas name to each log entry
            const logsWithPetugas = (data || []).map(log => ({
                ...log,
                users: { name: 'Admin SI-HARAT' }
            }));
            
            return logsWithPetugas;
        } catch (error) {
            console.error('Error fetching token purchase logs:', error);
            // Return empty array on error for graceful degradation
            return [];
        }
    }

    // Add new token purchase log
    async addTokenPurchaseLog(logData) {
        try {
            const { data, error } = await this.supabase
                .from('log_pengisian_token')
                .insert([logData])
                .select();
            
            if (error) {
                throw error;
            }
            return data[0];
        } catch (error) {
            console.error('Error adding token purchase log:', error);
            throw error;
        }
    }

    // Update token purchase log
    async updateTokenPurchaseLog(id, logData) {
        try {
            const { data, error } = await this.supabase
                .from('log_pengisian_token')
                .update(logData)
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error updating token purchase log:', error);
            throw error;
        }
    }

    // Delete token purchase log
    async deleteTokenPurchaseLog(id) {
        try {
            const { data, error } = await this.supabase
                .from('log_pengisian_token')
                .delete()
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error deleting token purchase log:', error);
            throw error;
        }
    }

    // Get token purchase summary
    async getTokenPurchaseSummary() {
        try {
            const { data, error } = await this.supabase
                .from('log_pengisian_token')
                .select(`
                    id,
                    nominal_pembelian,
                    jumlah_kwh,
                    tanggal_pengisian,
                    created_at
                `);
            
            if (error) throw error;
            
            // Calculate summary
            const summary = {
                total_purchases: data.length,
                total_nominal: data.reduce((sum, item) => sum + parseFloat(item.nominal_pembelian || 0), 0),
                total_kwh: data.reduce((sum, item) => sum + parseFloat(item.jumlah_kwh || 0), 0),
                average_purchase: data.length > 0 ? data.reduce((sum, item) => sum + parseFloat(item.nominal_pembelian || 0), 0) / data.length : 0
            };
            
            return summary;
        } catch (error) {
            console.error('Error fetching token purchase summary:', error);
            throw error;
        }
    }
}

// Initialize API
const electricityAPI = new ElectricityAPI();

// Export for use in other files
window.supabase = supabase;
window.electricityAPI = electricityAPI;

console.log('Supabase client and Electricity API initialized');