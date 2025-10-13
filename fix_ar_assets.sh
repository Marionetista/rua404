#!/bin/bash

echo "🔧 Corrigindo assets AR para o bundle iOS..."

# Paths
PROJECT_DIR="/Users/lucaspires/Documents/Flutter projects/rua404"
RUNNER_DIR="$PROJECT_DIR/ios/Runner"
ASSETS_DIR="$PROJECT_DIR/assets"

# Check if files exist
if [ ! -f "$ASSETS_DIR/ar_targets/orelhudo.png" ]; then
    echo "❌ Erro: orelhudo.png não encontrado em $ASSETS_DIR/ar_targets/"
    exit 1
fi

if [ ! -f "$ASSETS_DIR/ar_videos/orelhudo_1.mov" ]; then
    echo "❌ Erro: orelhudo_1.mov não encontrado em $ASSETS_DIR/ar_videos/"
    exit 1
fi

# Copy files to Runner directory
echo "📁 Copiando arquivos para Runner..."
cp "$ASSETS_DIR/ar_targets/orelhudo.png" "$RUNNER_DIR/"
cp "$ASSETS_DIR/ar_videos/orelhudo_1.mov" "$RUNNER_DIR/"

echo "✅ Arquivos copiados para $RUNNER_DIR/"

# Check if files are in Runner
if [ -f "$RUNNER_DIR/orelhudo.png" ] && [ -f "$RUNNER_DIR/orelhudo_1.mov" ]; then
    echo "✅ Arquivos encontrados no Runner!"
    echo ""
    echo "📋 PRÓXIMOS PASSOS NO XCODE:"
    echo ""
    echo "1. Abra: $PROJECT_DIR/ios/Runner.xcworkspace"
    echo "2. Clique com botão direito em 'Runner'"
    echo "3. Selecione 'Add Files to \"Runner\"'"
    echo "4. Navegue até: $RUNNER_DIR"
    echo "5. Selecione: orelhudo.png e orelhudo_1.mov"
    echo "6. Marque: 'Add to target: Runner' e 'Copy items if needed'"
    echo "7. Clique 'Add'"
    echo ""
    echo "8. Verifique se os arquivos aparecem sob 'Runner' no navegador"
    echo "9. Build e teste novamente!"
    echo ""
else
    echo "❌ Erro ao copiar arquivos"
    exit 1
fi

echo "🚀 Após adicionar no Xcode, execute: flutter run"
