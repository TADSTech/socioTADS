# !bin/bash

flutter pub get
flutter build web --release --wasm

firebase deploy --only hosting:sociotads