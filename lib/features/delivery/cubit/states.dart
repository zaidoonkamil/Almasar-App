abstract class DeliveryStates {}

class DeliveryInitialState extends DeliveryStates {}

class ValidationState extends DeliveryStates {}

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

class GetOrderLoadingState extends DeliveryStates {}
class GetOrderSuccessState extends DeliveryStates {}
class GetOrderErrorState extends DeliveryStates {}

class SocketGetOrderSuccessState extends DeliveryStates {}
