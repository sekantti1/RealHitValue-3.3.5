# Real Hit Value (WotLK 3.3.5a)

A lightweight World of Warcraft (3.3.5a) addon that modifies the default character sheet hit rating tooltips to reflect your **true** hit chance. 

By default, the Wrath of the Lich King client only calculates your hit chance based on gear rating. It completely ignores flat percentage bonuses from your talents or standard raid debuffs. This addon hooks into the UI to calculate your total hit chance, showing you exactly where your stats come from and exactly how far over or under the hit cap you are.

![Screenshot](https://github.com/sekantti1/RealHitValue-3.3.5/blob/master/Pictures/screenshot.jpg)

## ✨ Features

* **True Hit Calculation:** Combines hit from your gear, class talents, and guaranteed raid debuffs.
* **Detailed Breakdown:** Shows exactly where your hit chance is coming from directly on the tooltip:
  * Gear percentage
  * Talent percentage (dynamically fetches the localized name of the talent, e.g., `+3.00% (Precision)`)
  * Debuff percentage (e.g., `+3.00% (Misery)`)
* **Hit Cap Tracking:** Automatically calculates your effective hit cap based on your current stats and tells you:
  * **Missing to Cap:** How much raw hit rating you still need.
  * **Over Cap:** How much wasted hit rating you currently have equipped.
  * *Note: Calculates based on the spell hit cap (17%) and the special/yellow melee/ranged hit cap (8%).*
* **Localization Proof:** Pulls talent names directly from your client, meaning it works flawlessly on English, German, French, Russian, and Spanish clients.

## 🛠️ Installation

1. Click the **Code** button and select **Download ZIP**.
2. Extract the downloaded `.zip` file.
3. Rename the extracted folder to `RealHitValue` (make sure it doesn't have `-main` or `-master` at the end).
4. Move the `RealHitValue` folder into your WoW AddOns directory:
   `World of Warcraft\Interface\AddOns\`
5. Log into the game, ensure "Load out of date AddOns" is checked if necessary, and enable **Real Hit Value**.

## 📖 Usage

Simply open your Character window (`C`), click the **Melee**, **Ranged**, or **Spell** dropdown from the stats pane, and hover your mouse over your **Hit Rating**. 

The addon updates dynamically. If you change your gear or respec your talents, just move your mouse away and hover back over the hit rating to see your newly calculated values.

## 📝 Supported Talents & Debuffs

**Melee & Ranged:**
* Rogue/Warrior/Paladin: *Precision*
* Hunter: *Focused Aim*
* Death Knight: *Nerves of Cold Steel* (Frost)
* Shaman: *Dual Wield Specialization*

**Spell:**
* Mage: *Precision*, *Arcane Focus* (Arcane Main-Spec only)
* Warlock: *Suppression*
* Priest: *Shadow Focus*, *Misery* (Debuff)
* Druid: *Balance of Power*, *Improved Faerie Fire* (Debuff)
* Shaman: *Elemental Precision*
* Death Knight: *Virulence*