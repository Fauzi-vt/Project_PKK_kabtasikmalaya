import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/keluarga_provider.dart';
import 'keluarga_detail_page.dart';

class KeluargaListPage extends StatefulWidget {
  const KeluargaListPage({super.key});

  @override
  State<KeluargaListPage> createState() => _KeluargaListPageState();
}

class _KeluargaListPageState extends State<KeluargaListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup entrance animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Fetch data from provider right away
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KeluargaProvider>().getKeluargaData();
      _fadeController.forward();
    });

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: _buildAppBar(),
      body: Consumer<KeluargaProvider>(
        builder: (context, provider, _) {
          // ── State: Loading ─────────────────────────────────────────────────
          if (provider.isLoadingKeluarga) {
            return _buildLoadingState();
          }

          // ── State: Error ───────────────────────────────────────────────────
          if (provider.keluargaError != null) {
            return _buildErrorState(provider);
          }

          // Filter daftar berdasarkan query pencarian
          final filtered = provider.keluargaList.where((item) {
            final name =
                item['kepalaKeluarga'].toString().toLowerCase();
            final noKk = item['noKk'].toString().toLowerCase();
            return name.contains(_searchQuery) || noKk.contains(_searchQuery);
          }).toList();

          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                _buildSearchBar(),

                // Summary header
                _buildSummaryHeader(provider.keluargaList.length, filtered.length),

                // ── State: Kosong ─────────────────────────────────────────
                if (filtered.isEmpty)
                  Expanded(child: _buildEmptyState())
                // ── State: Berisi ─────────────────────────────────────────
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildKeluargaCard(filtered[index], index);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),

      // ── FloatingActionButton: Tambah Keluarga ──────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate ke form tambah keluarga
          // Navigator.pushNamed(context, '/tambah-keluarga');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Form Tambah KK akan tersedia segera'),
                ],
              ),
              backgroundColor: const Color(0xFF1A60D0),
              behavior: SnackBarBehavior.floating,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        backgroundColor: const Color(0xFF1A60D0),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah KK',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A60D0),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Daftar Keluarga (KK)',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Dasawisma Melati 01 · RT 003/RW 005',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          tooltip: 'Muat Ulang Data',
          onPressed: () =>
              context.read<KeluargaProvider>().getKeluargaData(),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari Nama Kepala Keluarga / No. KK...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1A60D0)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF1A60D0), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Summary Header ─────────────────────────────────────────────────────────
  Widget _buildSummaryHeader(int total, int shown) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _searchQuery.isEmpty
                ? '$total Kepala Keluarga Terdaftar'
                : '$shown dari $total hasil ditemukan',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF78909C),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Melati 01',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A60D0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu Item Keluarga ────────────────────────────────────────────────────
  Widget _buildKeluargaCard(Map<String, dynamic> item, int index) {
    final bool isVerified = item['status'] == 'Terverifikasi';
    final int anggota = item['jumlahAnggota'] as int? ?? 0;
    final String rt = item['rt'] ?? '-';
    final String rw = item['rw'] ?? '-';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60)),
      curve: Curves.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isVerified
                ? const Color(0xFFE3F2FD)
                : const Color(0xFFFFF3E0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KeluargaDetailPage(keluarga: item),
                ),
              );
            },
            splashColor: const Color(0xFF1A60D0).withValues(alpha: 0.07),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isVerified
                            ? [
                                const Color(0xFF1A60D0),
                                const Color(0xFF0F3E90)
                              ]
                            : [
                                const Color(0xFFFF8C00),
                                const Color(0xFFE65100)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info Keluarga
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['kepalaKeluarga'] ?? '-',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102851),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'No. KK: ${item['noKk'] ?? '-'}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF78909C),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isVerified
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['status'] ?? '-',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isVerified
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE65100),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // RT/RW badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F7FA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'RT $rt / RW $rw',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF546E7A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Jumlah anggota
                            Row(
                              children: [
                                const Icon(Icons.people_rounded,
                                    size: 12, color: Color(0xFF78909C)),
                                const SizedBox(width: 3),
                                Text(
                                  '$anggota Anggota',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF78909C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF1A60D0),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── State: Loading ─────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFF1A60D0)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Memuat data keluarga...',
            style: TextStyle(
              color: Color(0xFF546E7A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Dasawisma Melati 01',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── State: Error ───────────────────────────────────────────────────────────
  Widget _buildErrorState(KeluargaProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Color(0xFFD32F2F),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102851),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.keluargaError ?? 'Terjadi kesalahan yang tidak diketahui',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF78909C),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.getKeluargaData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A60D0),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ── State: Kosong ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                size: 48,
                color: Color(0xFF1A60D0),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tidak Ada Hasil Pencarian'
                  : 'Belum Ada Data Keluarga',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102851),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Coba gunakan kata kunci lain atau periksa ejaan Anda.'
                  : 'Mulai tambahkan data Kepala Keluarga dengan menekan tombol di bawah.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF78909C),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
