# 🏺 Artesanías Andinas — Flutter Clean Architecture

**SIS048 – Desarrollo de Software II | Universidad Andina del Cusco**
**Unidad II – Sesión 2: Inversión de Control con `get_it` + Scaffolding**

---

## 📋 Descripción del Proyecto

Aplicación móvil Flutter para la gestión de **productos artesanales andinos** del Cusco,
construida con **Clean Architecture** + **Inversión de Control** usando `get_it`.

Consume la [FakeStore API](https://fakestoreapi.com) como backend de demostración y
almacena favoritos en **SQLite** local (patrón Offline-First).

---

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                         # Punto de entrada + init IoC
│
├── core/                             # Infraestructura compartida
│   ├── di/
│   │   └── injection_container.dart  # ⭐ Contenedor get_it (IoC)
│   ├── database/
│   │   └── app_database.dart         # SQLite (sqflite)
│   ├── errors/
│   │   ├── failures.dart             # Failures del Domain
│   │   └── exceptions.dart           # Exceptions de la Data layer
│   ├── network/
│   │   └── dio_client.dart           # Cliente HTTP Dio
│   ├── router/
│   │   └── app_router.dart           # go_router
│   ├── theme/
│   │   └── app_theme.dart
│   └── usecases/
│       └── usecase.dart              # Interfaz genérica UseCase<T, P>
│
└── features/
    ├── products/                     # Feature: Catálogo de Productos
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── product_remote_datasource.dart   # API REST (Dio)
    │   │   │   └── product_local_datasource.dart    # SQLite (caché)
    │   │   ├── models/
    │   │   │   └── product_model.dart               # DTO + fromJson/toEntity
    │   │   └── repositories/
    │   │       └── product_repository_impl.dart     # Offline-First logic
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── product_entity.dart              # 🟢 Dart puro
    │   │   ├── repositories/
    │   │   │   └── product_repository.dart          # Interfaz (contrato)
    │   │   └── usecases/
    │   │       ├── get_products_usecase.dart
    │   │       ├── get_product_detail_usecase.dart
    │   │       └── search_products_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── product_controller.dart          # Riverpod Notifiers
    │       ├── pages/
    │       │   ├── product_list_page.dart
    │       │   └── product_detail_page.dart
    │       └── widgets/
    │           ├── product_card.dart
    │           └── category_filter_bar.dart
    │
    ├── favorites/                    # Feature: Favoritos (SQLite local)
    │   ├── data/ domain/ presentation/   (misma estructura)
    │
    └── auth/                         # Feature: Autenticación
        ├── data/ domain/ presentation/   (misma estructura)
```

---

## ⚙️ Requisitos Previos

| Herramienta | Versión mínima |
|------------|---------------|
| Flutter SDK | 3.19.0+ |
| Dart SDK | 3.3.0+ |
| Android Studio / VS Code | Cualquiera reciente |
| Dispositivo / Emulador | API 21+ (Android) |

---

## 🚀 Instalación y Ejecución

```bash
# 1. Clonar / abrir el proyecto
cd artesanias_app

# 2. Instalar dependencias
flutter pub get

# 3. Verificar el entorno
flutter doctor

# 4. Ejecutar en modo debug
flutter run

# 5. (Opcional) Generar código Riverpod
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔑 Concepto Central: Inversión de Control con `get_it`

### ¿Qué problema resuelve?

Sin IoC (❌ acoplamiento fuerte):
```dart
// La capa Presentation crea sus dependencias manualmente → MAL
class ProductListPage extends StatelessWidget {
  final dio = Dio();                                    // ❌
  final remote = ProductRemoteDataSourceImpl(dio);      // ❌
  final local  = ProductLocalDataSourceImpl(database);  // ❌
  final repo   = ProductRepositoryImpl(remote, local);  // ❌
  final uc     = GetProductsUseCase(repo);              // ❌
}
```

Con IoC / `get_it` (✅ desacoplamiento):
```dart
// La capa Presentation solo pide lo que necesita → BIEN
class ProductListController extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    final useCase = sl<GetProductsUseCase>(); // ✅ solo el contrato
    ...
  }
}
```

### Tipos de registro en `get_it`

| Tipo | Instancias | Cuándo usarlo |
|------|-----------|---------------|
| `registerFactory` | Nueva cada vez | Use Cases, Controllers |
| `registerLazySingleton` | Una, creada al 1er uso | Repositories, DataSources, Dio |
| `registerSingleton` | Una, creada al registrar | Base de datos, config global |

---

## 🗄️ Base de Datos Local (SQLite)

Tablas creadas automáticamente al iniciar la app:

| Tabla | Propósito |
|-------|-----------|
| `cached_products` | Caché offline de productos |
| `favorites` | Favoritos del usuario |
| `cached_user` | Sesión de usuario (Lab 12 → secure storage) |

---

## 🌐 API Utilizada (Demo)

**FakeStore API** — `https://fakestoreapi.com`

| Endpoint | Uso |
|----------|-----|
| `GET /products` | Lista de productos |
| `GET /products/:id` | Detalle de producto |
| `POST /auth/login` | Autenticación |

> **Nota:** En producción reemplazar por el backend real del proyecto semestral.

---

## 📐 Regla de Dependencia (visualización)

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER  (UI)        │
│  Widgets · Pages · Controllers          │
│              ↓ usa ↓                    │
├─────────────────────────────────────────┤
│           DOMAIN LAYER  (Core)          │  ← No depende de nadie
│  Entities · UseCases · Interfaces       │
│              ↑ implementa ↑             │
├─────────────────────────────────────────┤
│             DATA LAYER                  │
│  Models · RepoImpl · DataSources        │
└─────────────────────────────────────────┘

get_it registra las implementaciones (Data) contra
las interfaces (Domain), sin que Domain las conozca.
```

---

## 📚 Actividad de la Sesión

> Completar el scaffolding para agregar la entidad **`ArtisanEntity`** al proyecto:

1. Crear `features/artisans/domain/entities/artisan_entity.dart`
2. Crear `features/artisans/domain/repositories/artisan_repository.dart`
3. Crear `features/artisans/domain/usecases/get_artisans_usecase.dart`
4. Registrar en `core/di/injection_container.dart`
5. Verificar que la **Regla de Dependencia** se cumple

---

## 👨‍💻 Docentes

- Mg. Luis Álvaro Monzon Condori — lmonzon@uandina.edu.pe
- Mg. Yover Collantes Valer — ycollantes@uandina.edu.pe

**Universidad Andina del Cusco | Escuela de Ingeniería de Sistemas | 2026-I**
