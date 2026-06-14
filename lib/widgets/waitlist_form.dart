import 'package:flutter/material.dart';

import '../services/waitlist_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

class WaitlistForm extends StatefulWidget {
  const WaitlistForm({
    super.key,
    WaitlistService? waitlistService,
  }) : _waitlistService = waitlistService;

  final WaitlistService? _waitlistService;

  @override
  State<WaitlistForm> createState() => _WaitlistFormState();
}

class _WaitlistFormState extends State<WaitlistForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  late final WaitlistService _waitlistService =
      widget._waitlistService ?? WaitlistService();

  bool _isSubmitting = false;
  bool _submitted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitted || _isSubmitting) return;

    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _waitlistService.joinWaitlist(
        email: _emailController.text,
        name: _nameController.text,
      );

      if (!mounted) return;

      setState(() {
        _submitted = true;
        _isSubmitting = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _errorMessage =
            'No hemos podido guardar tu email. Inténtalo de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessMessage(
        message: 'Gracias, te avisaremos cuando 4drinking esté disponible.',
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Únete a la lista de espera',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Sé de los primeros en probar 4drinking cuando lancemos la app.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email *',
              hintText: 'tu@email.com',
            ),
            validator: (value) {
              if (value == null || !isValidWaitlistEmail(value)) {
                return 'Introduce un email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(
              labelText: 'Nombre (opcional)',
              hintText: 'Tu nombre',
            ),
            onFieldSubmitted: (_) => _submit(),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            FormErrorMessage(message: _errorMessage!),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Unirme a la lista',
            expanded: true,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body.copyWith(
                color: AppColors.success,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
