import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wintek/core/network/dio_provider.dart';
import 'package:wintek/features/game/aviator/domain/models/user_model.dart';
import 'package:wintek/features/game/aviator/service/user_service.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final UserService _userService;

  UserNotifier(this._userService) : super(const AsyncValue.loading());

  Future<void> fetchUser() async {
    state = const AsyncValue.loading();
    try {
      final result = await _userService.fetchUser();
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateWallet(double newWallet) {
    state = state.maybeWhen(
      data: (userModel) {
        if (userModel != null) {
          final updatedData = UserData(
            id: userModel.data.id,
            userName: userModel.data.userName,
            password: userModel.data.password,
            mobile: userModel.data.mobile,
            wallet: newWallet,
            verified: userModel.data.verified,
            otpVerified: userModel.data.otpVerified,
            status: userModel.data.status,
            isShow: userModel.data.isShow,
            picture: userModel.data.picture,
            branchName: userModel.data.branchName,
            bankName: userModel.data.bankName,
            accountHolderName: userModel.data.accountHolderName,
            accountNo: userModel.data.accountNo,
            ifscCode: userModel.data.ifscCode,
            referralCode: userModel.data.referralCode,
            upiId: userModel.data.upiId,
            upiNumber: userModel.data.upiNumber,
            betting: userModel.data.betting,
            transfer: userModel.data.transfer,
            fcm: userModel.data.fcm,
            personalNotification: userModel.data.personalNotification,
            mainNotification: userModel.data.mainNotification,
            starlineNotification: userModel.data.starlineNotification,
            galidisawarNotification: userModel.data.galidisawarNotification,
            transactionBlockedUntil: userModel.data.transactionBlockedUntil,
            transactionPermanentlyBlocked:
                userModel.data.transactionPermanentlyBlocked,
            createdAt: userModel.data.createdAt,
            updatedAt: userModel.data.updatedAt,
            authentication: userModel.data.authentication,
            lastLogin: userModel.data.lastLogin,
          );
          final updatedUserModel = UserModel(
            status: userModel.status,
            data: updatedData,
          );
          return AsyncValue.data(updatedUserModel);
        }
        return state;
      },
      orElse: () => state,
    );
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(ref.watch(dioProvider));
});

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
      (ref) => UserNotifier(ref.watch(userServiceProvider)),
    );
