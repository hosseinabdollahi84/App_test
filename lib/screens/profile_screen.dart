import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/pressable.dart';
import '../widgets/soft_button.dart';
import '../widgets/soft_toast.dart';

/// User profile: avatar header, stats, and grouped (visual-only) settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _soon(BuildContext context, String what) =>
      showSoftToast(context, '$what is coming soon');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Soft lavender wash behind the header.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 320,
          child: const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.profileGradient),
          ),
        ),
        CustomScrollView(
          key: const PageStorageKey('profile-scroll'),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverSafeArea(
              bottom: false,
              sliver: SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.md,
                  AppSpacing.page,
                  BottomNav.occupiedHeight(context) + AppSpacing.xs,
                ),
                sliver: SliverList.list(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Profile', style: AppText.title),
                        ),
                        SoftIconButton(
                          icon: Icons.settings_outlined,
                          onPressed: () => _soon(context, 'Settings'),
                          semanticLabel: 'Settings',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _ProfileHeader(),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: SoftButton(
                        label: 'Edit profile',
                        icon: Icons.edit_outlined,
                        variant: SoftButtonVariant.tinted,
                        height: 44,
                        onPressed: () => _soon(context, 'Editing'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _StatsRow(),
                    const SizedBox(height: AppSpacing.lg),
                    _SettingsGroup(
                      title: 'Shopping',
                      rows: [
                        _RowData(
                          Icons.receipt_long_rounded,
                          'My Orders',
                          AppColors.lilac,
                          AppColors.accentDeep,
                        ),
                        _RowData(
                          Icons.location_on_outlined,
                          'Addresses',
                          AppColors.mint,
                          Color(0xFF4FA88A),
                        ),
                        _RowData(
                          Icons.credit_card_rounded,
                          'Payment Methods',
                          AppColors.sky,
                          Color(0xFF5B8FD6),
                        ),
                      ],
                      onRowTap: (r) => _soon(context, r.label),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SettingsGroup(
                      title: 'Preferences',
                      rows: [
                        _RowData(
                          Icons.notifications_none_rounded,
                          'Notifications',
                          AppColors.butter,
                          Color(0xFFD9A441),
                        ),
                        _RowData(
                          Icons.tune_rounded,
                          'Settings',
                          AppColors.peach,
                          Color(0xFFE08E6D),
                        ),
                      ],
                      onRowTap: (r) => _soon(context, r.label),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SettingsGroup(
                      rows: [
                        _RowData(
                          Icons.logout_rounded,
                          'Logout',
                          AppColors.blush,
                          AppColors.danger,
                          destructive: true,
                        ),
                      ],
                      onRowTap: (r) => showSoftToast(
                        context,
                        'This is a demo, nothing to log out of',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            boxShadow: AppShadows.floating,
          ),
          child: const CircleAvatar(
            radius: 52,
            backgroundColor: AppColors.accentSoft,
            foregroundImage: NetworkImage(MockUser.avatarUrl),
            onForegroundImageError: _ignoreImageError,
            child: Icon(
              Icons.person_rounded,
              size: 48,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          MockUser.name,
          textAlign: TextAlign.center,
          style: AppText.title,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${MockUser.username}  ·  ${MockUser.email}',
          textAlign: TextAlign.center,
          style: AppText.caption.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(value: MockUser.orders, label: 'Orders'),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(value: MockUser.wishlist, label: 'Wishlist'),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(value: MockUser.reviews, label: 'Reviews'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.mdAll,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppText.title.copyWith(color: AppColors.accentDeep),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class _RowData {
  const _RowData(
    this.icon,
    this.label,
    this.tint,
    this.iconColor, {
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final Color tint;
  final Color iconColor;
  final bool destructive;
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    this.title,
    required this.rows,
    required this.onRowTap,
  });

  final String? title;
  final List<_RowData> rows;
  final ValueChanged<_RowData> onRowTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xxs,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              title!,
              style: AppText.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.lgAll,
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0)
                  const Padding(
                    padding: EdgeInsets.only(left: 72, right: AppSpacing.md),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.surfaceMuted,
                    ),
                  ),
                _SettingsRow(data: rows[i], onTap: () => onRowTap(rows[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data, required this.onTap});

  final _RowData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      semanticLabel: data.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: data.tint,
                borderRadius: AppRadii.smAll,
              ),
              child: Icon(data.icon, size: 20, color: data.iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.label.copyWith(
                  fontSize: 15,
                  color: data.destructive
                      ? AppColors.danger
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (!data.destructive)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}

// Falls back to the icon child when offline.
void _ignoreImageError(Object error, StackTrace? stackTrace) {}
