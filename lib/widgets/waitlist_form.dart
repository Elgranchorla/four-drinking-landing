import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../config/landing_config.dart';
import '../services/waitlist_service.dart';
import '../utils/legal_navigation.dart';
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
  bool _marketingConsent = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _waitlistService.joinWaitlist(
        email: _emailController.text,
        name: _nameController.text,
        privacyAccepted: true,
        marketingConsent: _marketingConsent,
      );

      if (!mounted) return;

      _emailController.clear();
      _nameController.clear();
      _formKey.currentState?.reset();
      setState(() => _marketingConsent = false);

      setState(() {
        _successMessage =
            'Gracias, te avisaremos cuando 4drinking esté disponible.';
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
          if (_successMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _SuccessMessage(message: _successMessage!),
          ],
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
          const SizedBox(height: AppSpacing.md),
          FormField<bool>(
            initialValue: false,
            validator: (value) {
              if (value != true) {
                return 'Debes aceptar la Política de Privacidad para continuar';
              }
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ConsentCheckboxTile(
                    value: state.value ?? false,
                    onChanged: state.didChange,
                    child: Text.rich(
                      TextSpan(
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'He leído y acepto la ',
                          ),
                          TextSpan(
                            text: 'Política de Privacidad',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => openLegalLink(
                                    context,
                                    LandingConfig.privacyPolicyUrl,
                                  ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                  if (state.hasError) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      child: Text(
                        state.errorText!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          _ConsentCheckboxTile(
            value: _marketingConsent,
            onChanged: (value) {
              setState(() => _marketingConsent = value ?? false);
            },
            child: Text(
              'Quiero recibir novedades, invitaciones beta y comunicaciones '
              'sobre 4drinking.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
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
          const SizedBox(height: AppSpacing.lg),
          const _LegalLinks(),
        ],
      ),
    );
  }
}

class _ConsentCheckboxTile extends StatelessWidget {
  const _ConsentCheckboxTile({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
    const separatorStyle = TextStyle(color: AppColors.textSecondary);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        _LegalLink(
          label: 'Política de Privacidad',
          url: LandingConfig.privacyPolicyUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Política de Cookies',
          url: LandingConfig.cookiesPolicyUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Términos y Condiciones',
          url: LandingConfig.termsUrl,
          style: linkStyle,
        ),
        const Text('·', style: separatorStyle),
        _LegalLink(
          label: 'Aviso Legal',
          url: LandingConfig.legalNoticeUrl,
          style: linkStyle,
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({
    required this.label,
    required this.url,
    required this.style,
  });

  final String label;
  final String url;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openLegalLink(context, url),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: style.color,
          fontWeight: style.fontWeight,
          decoration: style.decoration,
        ),
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
