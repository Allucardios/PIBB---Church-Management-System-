import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/theme.dart';
import '../../data/providers/profile_provider.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre e Manual')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 60, color: AppTheme.primary),
                  SizedBox(height: 10),
                  Text(
                    'PIBB Management System',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Versão 1.0.1', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Divider(height: 40),

            // Development Info
            _buildSectionTitle('Ficha Técnica'),
            const Text('Desenvolvido para gestão financeira de igrejas.'),
            const SizedBox(height: 10),
            const Text(
              'Ferramentas Utilizadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Flutter & Dart (Frontend & Logic)'),
            const Text('• Riverpod (Gestão de Estado)'),
            const Text('• Supabase (Backend & Database)'),
            const Text('• PostgreSQL (Banco de Dados Relacional)'),
            const Divider(height: 40),

            // Manual
            _buildSectionTitle('Manual do Utilizador'),

            // Common Features (Everyone)
            _buildManualItem(
              'Dashboard',
              'Visão geral das finanças anuais. Mostra saldo total e gráficos de evolução.',
            ),
            _buildManualItem(
              'Receitas e Despesas',
              'Adicione novas transacções clicando no botão "+". Use o ícone de calendário no topo para filtrar por mês e ano específicos. Arraste a lista para baixo para actualizar.',
            ),

            // Role Based Features
            if (profile != null) ...[
              Builder(
                builder: (context) {
                  final level = profile.level.trim().toLowerCase();
                  final isManagerOrAdmin =
                      level == 'admin' || level == 'manager';
                  final isAdmin = level == 'admin';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isManagerOrAdmin) ...[
                        _buildManualItem(
                          'Gestão de Contas (Tesouraria)',
                          'Apenas Managers e Admins podem criar ou editar contas bancárias/caixa na aba "Contas".',
                        ),
                        _buildManualItem(
                          'Relatórios',
                          'Acesso a relatórios detalhados para impressão ou exportação.',
                        ),
                      ],
                      if (isAdmin) ...[
                        const Divider(),
                        _buildSectionTitle('Área Administrativa'),
                        _buildManualItem(
                          'Gestão de Utilizadores',
                          'Como Administrador, pode adicionar novos utilizadores, inactivar contas e redefinir níveis de acesso no menu "Utilizadores".',
                        ),
                        _buildManualItem(
                          'Configurações Avançadas',
                          'Acesso total a logs de sistema e configurações globais da igreja.',
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],

            const Divider(height: 40),
            const Center(
              child: Text(
                '© 2026 PIBB Management System. Todos os direitos reservados.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildManualItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
