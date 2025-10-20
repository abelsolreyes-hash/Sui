#!/usr/bin/env bash
set -e

# ============================================================
# 🧠 WayLearn – Sui Developer Bootcamp (Octubre)
# Proyecto completo reproducido día a día
# ============================================================

PROJECT="sui-bootcamp-project"
mkdir -p $PROJECT/{sources,scripts,frontend}
cd $PROJECT

# ------------------------------------------------------------
# Move.toml
# ------------------------------------------------------------
cat <<'EOF' > Move.toml
[package]
name = "sui_bootcamp_project"
version = "0.0.1"
edition = "2024.beta"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/Sui.git", subdir = "crates/sui-framework", rev = "framework/testnet" }

[addresses]
sui_bootcamp = "0x0"
EOF

# ------------------------------------------------------------
# README.md
# ------------------------------------------------------------
cat <<'EOF' > README.md
# 🧠 WayLearn - Sui Developer Bootcamp (Octubre)

Proyecto reproducido paso a paso siguiendo el Bootcamp de WayLearn y Sui.
Incluye módulos Move, scripts de despliegue y un frontend de demostración.
EOF

# ------------------------------------------------------------
# sources/Counter.move
# ------------------------------------------------------------
cat <<'EOF' > sources/Counter.move
module sui_bootcamp::counter {
    use sui::tx_context::{TxContext};
    use sui::object::{Self, UID};

    struct Counter has key {
        id: UID,
        value: u64
    }

    public fun init(ctx: &mut TxContext): Counter {
        Counter { id: object::new(ctx), value: 0 }
    }

    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    public fun get_value(counter: &Counter): u64 {
        counter.value
    }
}
EOF

# ------------------------------------------------------------
# sources/SimpleObject.move
# ------------------------------------------------------------
cat <<'EOF' > sources/SimpleObject.move
module sui_bootcamp::simple_object {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};

    struct SimpleObject has key {
        id: UID,
        name: vector<u8>
    }

    public fun create(name: vector<u8>, ctx: &mut TxContext): SimpleObject {
        SimpleObject { id: object::new(ctx), name }
    }

    public fun get_name(obj: &SimpleObject): vector<u8> {
        obj.name
    }
}
EOF

# ------------------------------------------------------------
# sources/BasicNFT.move
# ------------------------------------------------------------
cat <<'EOF' > sources/BasicNFT.move
module sui_bootcamp::basic_nft {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};

    struct BasicNFT has key, store {
        id: UID,
        name: vector<u8>,
        url: vector<u8>
    }

    public fun mint(name: vector<u8>, url: vector<u8>, ctx: &mut TxContext): BasicNFT {
        BasicNFT { id: object::new(ctx), name, url }
    }
}
EOF

# ------------------------------------------------------------
# sources/NFTCollection.move
# ------------------------------------------------------------
cat <<'EOF' > sources/NFTCollection.move
module sui_bootcamp::nft_collection {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use sui_bootcamp::basic_nft;

    struct NFTCollection has key {
        id: UID,
        name: vector<u8>,
        nfts: vector<basic_nft::BasicNFT>
    }

    public fun init(name: vector<u8>, ctx: &mut TxContext): NFTCollection {
        NFTCollection { id: object::new(ctx), name, nfts: vector[] }
    }

    public fun add_nft(collection: &mut NFTCollection, nft: basic_nft::BasicNFT) {
        vector::push_back(&mut collection.nfts, nft);
    }

    public fun get_count(collection: &NFTCollection): u64 {
        vector::length(&collection.nfts)
    }
}
EOF

# ------------------------------------------------------------
# sources/MinterRole.move
# ------------------------------------------------------------
cat <<'EOF' > sources/MinterRole.move
module sui_bootcamp::minter_role {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};

    struct MinterCap has key {
        id: UID,
        name: vector<u8>
    }

    public fun create_cap(name: vector<u8>, ctx: &mut TxContext): MinterCap {
        MinterCap { id: object::new(ctx), name }
    }
}
EOF

# ------------------------------------------------------------
# scripts/publish.sh
# ------------------------------------------------------------
cat <<'EOF' > scripts/publish.sh
#!/usr/bin/env bash
set -e
sui client publish --gas-budget 30000000
EOF
chmod +x scripts/publish.sh

# ------------------------------------------------------------
# scripts/demo_mint.sh
# ------------------------------------------------------------
cat <<'EOF' > scripts/demo_mint.sh
#!/usr/bin/env bash
set -e
PACKAGE_ID="<REEMPLAZA_CON_TU_PACKAGE_ID>"
sui client call --package $PACKAGE_ID --module basic_nft --function mint --args "NFT de ejemplo" "https://gateway.pinata.cloud/ipfs/example.png" --gas-budget 20000000
EOF
chmod +x scripts/demo_mint.sh

# ------------------------------------------------------------
# frontend/index.html
# ------------------------------------------------------------
cat <<'EOF' > frontend/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sui Bootcamp Demo</title>
  <link rel="stylesheet" href="style.css">
</head>
<body class="bg-gray-900 text-white flex flex-col items-center justify-center h-screen">
  <h1 class="text-3xl font-bold mb-4">🧠 Sui Bootcamp Demo</h1>
  <button id="mintBtn" class="bg-blue-600 px-4 py-2 rounded">Mint NFT</button>
  <script src="app.js"></script>
</body>
</html>
EOF

# ------------------------------------------------------------
# frontend/app.js
# ------------------------------------------------------------
cat <<'EOF' > frontend/app.js
document.getElementById('mintBtn').addEventListener('click', async () => {
  alert('Simulación de minteo NFT desde frontend');
});
EOF

# ------------------------------------------------------------
# Inicializar Git
# ------------------------------------------------------------
git init
git add .
git commit -m "Proyecto completo Bootcamp Sui (WayLearn - Octubre)"
echo "✅ Proyecto Sui Bootcamp creado completamente en $(pwd)"