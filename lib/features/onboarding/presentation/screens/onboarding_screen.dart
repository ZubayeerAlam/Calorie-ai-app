import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/activity_page.dart';
import '../pages/birthday_page.dart';
import '../pages/diet_page.dart';
import '../pages/dinner_page.dart';
import '../pages/gender_page.dart';
import '../pages/goal_page.dart';
import '../pages/height_page.dart';
import '../pages/name_page.dart';
import '../pages/personalizing_page.dart';
import '../pages/plan_page.dart';
import '../pages/weight_page.dart';

/// Hosts the onboarding steps: back arrow + progress bar + step counter on
/// top, the current step's page, and a Continue / Finish button at the bottom.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static Widget _pageFor(OnboardingStep step) => switch (step) {
    OnboardingStep.name => const NamePage(),
    OnboardingStep.gender => const GenderPage(),
    OnboardingStep.birthday => const BirthdayPage(),
    OnboardingStep.height => const HeightPage(),
    OnboardingStep.weight => const WeightPage(),
    OnboardingStep.goal => const GoalPage(),
    OnboardingStep.activity => const ActivityPage(),
    OnboardingStep.diet => const DietPage(),
    OnboardingStep.dinner => const DinnerPage(),
    OnboardingStep.plan => const PlanPage(),
  };

  void _onContinue(BuildContext context, OnboardingProvider onboarding) {
    if (!onboarding.isLastStep) {
      FocusScope.of(context).unfocus();
      onboarding.next();
      return;
    }
    context.read<ProfileProvider>().completeOnboarding(
      onboarding.profile,
      onboarding.goals,
    );
    // The router's redirect would also do this once the profile notifies.
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    final base = AppTheme.light;
    // After the last setup step, show the loader until the plan is ready.
    final isPersonalizing =
        onboarding.step == OnboardingStep.plan && !onboarding.planReady;

    return Theme(
      data: base.copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: base.textTheme.apply(fontFamily: 'Outfit'),
        primaryTextTheme: base.primaryTextTheme.apply(fontFamily: 'Outfit'),
      ),
      child: PopScope(
        canPop: onboarding.isFirstStep,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) onboarding.back();
        },
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontFamily: 'Outfit'),
              child: isPersonalizing
                  ? PersonalizingPage(
                      onCompleted: onboarding.markPlanReady,
                      onClose: onboarding.back,
                    )
                  : Column(
                      children: [
                        _ProgressHeader(onboarding: onboarding),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              // Pin pages to the top instead of centering them.
                              layoutBuilder: (current, previous) => Stack(
                                alignment: Alignment.topCenter,
                                children: [...previous, ?current],
                              ),
                              child: KeyedSubtree(
                                key: ValueKey(onboarding.step),
                                child: _pageFor(onboarding.step),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.divider,
                        ),
                        _BottomButton(
                          label: onboarding.isLastStep ? 'Finish' : 'Continue',
                          onPressed: onboarding.canContinue
                              ? () => _onContinue(context, onboarding)
                              : null,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.onboarding});

  final OnboardingProvider onboarding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              width: 84,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (!onboarding.isFirstStep) {
                      onboarding.back();
                    } else if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 26,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: onboarding.progress),
                duration: const Duration(milliseconds: 300),
                builder: (_, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: AppColors.track,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            SizedBox(
              width: 84,
              child: Text(
                '${onboarding.stepIndex + 1} / ${onboarding.stepCount}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 18, color: AppColors.textDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.paddingOf(context).bottom + 4,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 57,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textDark,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            disabledForegroundColor: AppColors.textDark.withValues(alpha: 0.5),
            elevation: 0,
            shape: const StadiumBorder(),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
