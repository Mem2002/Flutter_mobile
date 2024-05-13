import 'package:injectable/injectable.dart';

abstract class IConfigBase {
  String get serverApi;

  String get enviroment;
}

@Environment("beta")
@Injectable(as: IConfigBase)
class BetaConfig implements IConfigBase {
  @override
  String serverApi = "beta-api.edutalk.edu.vn";

  @override
  String enviroment = "beta";
}

// @Environment("stage")
// @Injectable(as: IApiBase)
class StageConfig implements IConfigBase {
  @override
  String serverApi = "";

  @override
  String enviroment = "stage";
}

@Environment("product")
@Injectable(as: IConfigBase)
class ProductConfig implements IConfigBase {
  @override
  String serverApi = "api2.edutalk.edu.vn";

  @override
  String enviroment = "product";
}
