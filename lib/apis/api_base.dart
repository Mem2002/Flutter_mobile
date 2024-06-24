import 'package:injectable/injectable.dart';

abstract class IConfigBase {
  String get serverApi;

  String get enviroment;
}

@Environment("test")
@Injectable(as: IConfigBase)
class BetaConfig implements IConfigBase {
  @override
  String serverApi = "bemobile-ajl2.onrender.com";

  @override
  String enviroment = "test";
}

// @Environment("stage")
// @Injectable(as: IApiBase)
// class StageConfig implements IConfigBase {
//   @override
//   String serverApi = "";

//   @override
//   String enviroment = "stage";
// }

// @Environment("product")
// @Injectable(as: IConfigBase)
// class ProductConfig implements IConfigBase {
//   @override
//   String serverApi = "bemobile-ajl2.onrender.com";

//   @override
//   String enviroment = "product";
// }
