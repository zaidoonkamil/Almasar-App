abstract class DeliveryStates {}

class DeliveryInitialState extends DeliveryStates {}

class ValidationState extends DeliveryStates {}

class VerifyTokenLoadingState extends DeliveryStates {}
class VerifyTokenSuccessState extends DeliveryStates {}
class VerifyTokenErrorState extends DeliveryStates {}

class GetProfileLoadingState extends DeliveryStates {}
class GetProfileSuccessState extends DeliveryStates {}
class GetProfileErrorStates extends DeliveryStates {}

class GetAdsLoadingState extends DeliveryStates {}
class GetAdsSuccessState extends DeliveryStates {}
class GetAdsErrorStates extends DeliveryStates {}

class GetDashboardDeliveryLoadingState extends DeliveryStates {}
class GetDashboardDeliverySuccessState extends DeliveryStates {}
class GetDashboardDeliveryErrorStates extends DeliveryStates {}

class GetTodayDashboardDeliveryLoadingState extends DeliveryStates {}
class GetTodayDashboardDeliverySuccessState extends DeliveryStates {}
class GetTodayDashboardDeliveryErrorStates extends DeliveryStates {}

class AddLocationLoadingState extends DeliveryStates {}
class AddLocationSuccessState extends DeliveryStates {}
class AddLocationErrorState extends DeliveryStates {}

class DeliveryStatusLoadingState extends DeliveryStates {}
class DeliveryStatusSuccessState extends DeliveryStates {}
class DeliveryStatusErrorState extends DeliveryStates {}

class DeliveryAcceptLoadingState extends DeliveryStates {}
class DeliveryAcceptSuccessState extends DeliveryStates {}
class DeliveryAcceptErrorState extends DeliveryStates {}

class ChangeStatusOrderLoadingState extends DeliveryStates {}
class ChangeStatusOrderSuccessState extends DeliveryStates {}
class ChangeStatusOrderErrorState extends DeliveryStates {}

class GetOrderLoadingState extends DeliveryStates {}
class GetOrderSuccessState extends DeliveryStates {}
class GetOrderErrorState extends DeliveryStates {}

class GetActiveOrderLoadingState extends DeliveryStates {}
class GetActiveOrderSuccessState extends DeliveryStates {}
class GetActiveOrderErrorState extends DeliveryStates {}

class SocketGetOrderSuccessState extends DeliveryStates {}
