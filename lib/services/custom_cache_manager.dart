import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const String key = "customCacheKey";

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7), // Tempo de validade do cache
            maxNrOfCacheObjects: 100, // Número máximo de objetos em cache
            fileService: HttpFileService(), // Serviço HTTP padrão
          ),
        );

  static final CustomCacheManager instance = CustomCacheManager._();

  Future<void> clearCache() async {
    await instance.emptyCache(); // Limpa o cache do disco e memória
  }
}