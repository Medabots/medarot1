; Patch specific (non-vwf) tilesets, included as part of hack.asm

PatchTilesetStart::
PatchTilesetStartInventoryText::
  INCBIN "build/tilesets/patch/Inventory.malias"
PatchTilesetEndInventoryText::
PatchTilesetStartMapText::
  INCBIN "build/tilesets/MainDialog.malias" ; Just cheat and use main dialog
PatchTilesetEndMapText::
PatchTilesetStartShopText::
  INCBIN "build/tilesets/patch/ShopText.malias"
PatchTilesetEndShopText::
PatchTilesetStartMainMenuText::
  INCBIN "build/tilesets/patch/MainMenu.malias"
PatchTilesetEndMenuText::
PatchTilesetStartMainMenuGraphics::
  INCBIN "build/tilesets/patch/MainMenuGraphics.malias"
PatchTilesetEndMainMenuGraphics::
PatchTilesetStartSaveScreenText::
  INCBIN "build/tilesets/patch/SaveScreen.malias"
PatchTilesetEndSaveScreenText::