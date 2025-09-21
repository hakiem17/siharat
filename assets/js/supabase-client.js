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

// Notulen Management API Functions
class NotulenAPI {
    constructor() {
        this.supabase = supabase;
    }

    // Get all notulen
    async getNotulen(limit = 50) {
        try {
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .select('*')
                .order('tanggal_rapat', { ascending: false })
                .limit(limit);
            
            if (error) {
                console.error('Supabase error:', error);
                // Return empty array if table doesn't exist
                if (error.code === 'PGRST116' || error.message.includes('relation "notulen_rapat" does not exist')) {
                    console.warn('Table notulen_rapat does not exist, returning empty array');
                    return [];
                }
                throw error;
            }
            
            return data || [];
        } catch (error) {
            console.error('Error fetching notulen:', error);
            return [];
        }
    }

    // Get notulen by ID
    async getNotulenById(id) {
        try {
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .select('*')
                .eq('id', id)
                .single();
            
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching notulen by ID:', error);
            throw error;
        }
    }

    // Add new notulen
    async addNotulen(notulenData) {
        try {
            console.log('NotulenAPI: Attempting to insert notulen:', notulenData);
            
            // Handle image uploads if present
            let imageData = [];
            if (notulenData.gambar_notulen && notulenData.gambar_notulen.length > 0) {
                console.log('Uploading images to Supabase Storage...');
                imageData = await this.uploadImages(notulenData.gambar_notulen);
                console.log('Images uploaded successfully:', imageData);
            }
            
            // Remove created_by if it's not a valid UUID to avoid RLS issues
            const cleanData = { ...notulenData };
            if (cleanData.created_by && !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(cleanData.created_by)) {
                console.log('Invalid UUID for created_by, removing it');
                delete cleanData.created_by;
            }
            
            // Replace base64 images with storage URLs
            cleanData.gambar_notulen = imageData;
            
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .insert([cleanData])
                .select();
            
            if (error) {
                console.error('Supabase insert error:', error);
                throw error;
            }
            
            console.log('NotulenAPI: Successfully inserted:', data);
            return data[0];
        } catch (error) {
            console.error('Error adding notulen:', error);
            throw error;
        }
    }

    // Upload images to Supabase Storage
    async uploadImages(images) {
        const uploadedImages = [];
        
        for (let i = 0; i < images.length; i++) {
            const image = images[i];
            const fileName = `${Date.now()}-${i}-${image.name}`;
            const filePath = `notulen-images/${fileName}`;
            
            try {
                // Convert base64 to blob
                const response = await fetch(image.data);
                const blob = await response.blob();
                
                // Upload to Supabase Storage
                const { data, error } = await this.supabase.storage
                    .from('notulen-images')
                    .upload(filePath, blob, {
                        contentType: image.type,
                        upsert: false
                    });
                
                if (error) {
                    console.error('Error uploading image:', error);
                    throw error;
                }
                
                // Get public URL
                const { data: urlData } = this.supabase.storage
                    .from('notulen-images')
                    .getPublicUrl(filePath);
                
                uploadedImages.push({
                    name: image.name,
                    path: filePath,
                    url: urlData.publicUrl,
                    size: blob.size,
                    type: image.type
                });
                
                console.log(`Image ${i + 1} uploaded successfully:`, fileName);
                
            } catch (error) {
                console.error(`Error uploading image ${i + 1}:`, error);
                throw error;
            }
        }
        
        return uploadedImages;
    }

    // Update notulen
    async updateNotulen(id, notulenData) {
        try {
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .update(notulenData)
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error updating notulen:', error);
            throw error;
        }
    }

    // Delete notulen
    async deleteNotulen(id) {
        try {
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .delete()
                .eq('id', id)
                .select();
            
            if (error) throw error;
            return data[0];
        } catch (error) {
            console.error('Error deleting notulen:', error);
            throw error;
        }
    }

    // Search notulen
    async searchNotulen(searchTerm, filters = {}) {
        try {
            let query = this.supabase
                .from('notulen_rapat')
                .select('*');

            // Apply text search
            if (searchTerm) {
                query = query.or(`judul_rapat.ilike.%${searchTerm}%,pemimpin_rapat.ilike.%${searchTerm}%,lokasi.ilike.%${searchTerm}%`);
            }

            // Apply filters
            if (filters.tanggal) {
                query = query.eq('tanggal_rapat', filters.tanggal);
            }

            if (filters.pemimpin) {
                query = query.ilike('pemimpin_rapat', `%${filters.pemimpin}%`);
            }

            query = query.order('tanggal_rapat', { ascending: false });

            const { data, error } = await query;
            
            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error searching notulen:', error);
            return [];
        }
    }

    // Get notulen statistics
    async getNotulenStats() {
        try {
            const { data, error } = await this.supabase
                .from('notulen_rapat')
                .select('tanggal_rapat, peserta_rapat');
            
            if (error) throw error;
            
            const today = new Date().toISOString().split('T')[0];
            const thisMonth = new Date().getMonth();
            const thisYear = new Date().getFullYear();
            
            const stats = {
                total: data.length,
                bulan_ini: data.filter(notulen => {
                    const notulenDate = new Date(notulen.tanggal_rapat);
                    return notulenDate.getMonth() === thisMonth && notulenDate.getFullYear() === thisYear;
                }).length,
                hari_ini: data.filter(notulen => notulen.tanggal_rapat === today).length,
                total_peserta: data.reduce((total, notulen) => {
                    return total + (notulen.peserta_rapat ? notulen.peserta_rapat.split(',').length : 0);
                }, 0)
            };
            
            return stats;
        } catch (error) {
            console.error('Error fetching notulen stats:', error);
            return {
                total: 0,
                bulan_ini: 0,
                hari_ini: 0,
                total_peserta: 0
            };
        }
    }
}

// Initialize API
const electricityAPI = new ElectricityAPI();
const notulenAPI = new NotulenAPI();

// Export for use in other files
window.supabase = supabase;
window.electricityAPI = electricityAPI;
window.notulenAPI = notulenAPI;

console.log('Supabase client, Electricity API, and Notulen API initialized');