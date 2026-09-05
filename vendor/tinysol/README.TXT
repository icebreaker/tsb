
         TINYSOL USER'S GUIDE

        Verison 1.3, 05/25/2026
            ClassicBits.net

 ##### ##### #   # #   #  ####  ###  #
   #     #   ##  #  # #  #     #   # #
   #     #   # # #   #    ###  #   # #
   #     #   #  ##   #       # #   # #
   #   ##### #   #   #   ####   ###  #####

        Klondike Solitare for DOS
              in under 3KB


------------==[ BASIC GAMEPLAY ]==------------

TinySol is designed to be keyboard friendly,
a mouse is optional.

Piles are represented by keys 1-9 and A-D.
Press multiple times to select more cards
or use up/down arrows.

An indicator blinks to show your selection.

Simply select the source then destination.


-------------==[ GAME LAYOUT ]==--------------

 8 9   A B C D      A-D = Foundation Piles
 1 2 3 4 5 6 7      1-7 = Tableau Piles
                      8 = Deck Pile
                      9 = Waste Pile


----------------==[ HELP ]==------------------

Help is displayed when the game is launched
and vanishes upon first input.

TIP:  Re-display help by switching video modes
(F1-F4).  You can select the same video mode.


----------==[ KEYBOARD CONTROLS ]==-----------
       (features vary by version)

    1-7: Select a tableau pile
    A-D: Select a foundation pile
8/Space: Deal 3 cards
9/Enter: Select card from draw pile
    Tab: Auto-send card to foundation pile
         (same as right click)
Up/Down: Modify selection within pile
 Escape: Cancel current selection
      +: Save game state
      -: Restore game state
      f: Auto-finish game if able
      n: New game
      x: Exit game
      s: Save game to a file
     F1: Video mode 640x200 CGA
     F2: Video mode 640x400 AT&T 6300
     F3: Video mode 640x350 EGA
     F4: Video mode 640x480 VGA
  Shift: Prevent automatic savegame replay
         (hold at launch)


------------==[ MOUSE CONTROLS ]==------------
 * Click the source then destination
 * Right click auto-sends to a foundation
   pile (same as TAB)
 * Click N (top right) for New Game
 * Click X (top right) to Exit


----------------==[ ABOUT ]==-----------------

 TinySol is a Klondike Solitaire game
 designed for:
  * Good display on vintage displays
    including monochrome screens.
  * Keyboard friendly gameplay
  * Small footprint

 FEATURES:
  * Runs on anything (DOS 2.0 and up,
    8088 CPU and up, CGA-VGA video)
  * Fits anywhere (small 3KB footprint)
  * Easy viewing on vintage screens
  * Save/Restore gamestate during play
  * Save/Load games to disk
  * Playable with a keyboard or a mouse
  * Scoring.  Same as Microsoft Solitaire
    (sans timer)
  * Auto-finish
  * Switch video modes on the fly


---------------==[ HISTORY ]==----------------

 TinySol has been in development since
 2021.  I originally wanted a tiny game
 to shoehorn into ROM images for GRiD
 computers and that would leverage the
 sharp 640x400 AT&T 6300 monchrome video
 (few games do).


----------==[ VERSION HISTORY ]==-------------

05/25/2026 TinySol 1.3
 -Code/Size optimization
 -Bug fix, was pushing but not popping in shuffle
  loop (didn't seem to manifest an issue though).
 -Improved mouse input, wasn't waiting for click
  release before processing input resulting in rare
  savegame errors.
 -Size optimization by reworking TinySprites to use
  a single sprite set vs. separate High/Low rez sets.
  (Low rez now uses every other byte.)
 -Size optimizations reworking some JMP to JMP short.
 -Implemented assembly of multiple versions with
  varying features.  (Full, Medium, Tiny, Micro, etc.)
  with the smallest (micro) being 1.8KB, playable
  but with very limited features.

05/27/2024 TinySol 1.2
 -Size optimizations
 -Switch to color video modes due to widespread
  mono mode compatibility issues across hardware
 -Randomization technique update
 -Renamed from MonoSol to TinySol
 -New Feature: Scoring
 -New Feature: Autofinish game
 -New Feature: Save/Load game file, with replay
 
11/29/2022 MonoSol 1.1
 -Size optimizations
 -Performance optimizations
 -Added ending screen
 
10/06/2022 MonoSol 1.0
 -Initial release

------------==[ KNOWN ISSUES ]==--------------

 -Rarely a savegame contains errors.  Usually
  an extra erroneous input.
  
 -When executing from floppy on real hardware
  (IBM 5160) upon winning (replayed a saved win),
  pressing 'x' the game doesn't immediately exit
  to DOS from the congrats screen.  It takes some
  fiddling.  This was discovered just before
  leaving for VCF 2026 when testing the floppy's
  produced for distribution.
 
---------------==[ PRO TIPS ]==---------------

 Save/Load game files
  * 's' saves the current game to a file named
    "SAVE" (overwrites so rename ones you want
    to keep).  Example: REN SAVE SAVE.001
  * Load game files via command line at launch.
    Example: TINYSOL.COM SAVE
  * Loaded games are auto-replayed, except the
    last move.  Holding SHIFT avoids replay.

 Winnable Games
  * The 'WINS' directory contains winnable games.
    Ex: TINYSOL.COM WINS\WIN.001 (Shift-Enter)

 Auto-Finish
  * If you've got the game beat and just need to
    put all the cards away pressing 'f' will
    auto-sends them home (if legal).

 Undo and Do-Over Tactics
  * '+/-' keys instantly Save/Restore the
    gamesate, save before questionable moves.
  * Restart the current game with '-' as long
    as you haven't already saved another state.
    If you have then use the next method.
  * Restart the current game by pressing 's'
    to save a file, 'x' to exit, then launch
    "TINYSOL.COM SAVE" while holding SHIFT to
    prevent automatic reply.


---------------==[ VERSIONS ]==---------------

Code Golf is the challenge of writing
tiny software and is a large part of why
I continue optimizing.  Tinysol comes in
several configurations ranging from
3.5KB down to only 1.8KB.

Version/Feature Table:
                           Mini Mini
                           High Low  Ultra
            Full Med. Tiny Rez  Rez  Micro
------------------------------------------
Size:       3.5K 3.0K 2.8K 2.4K 2.2K 1.8K
------------------------------------------
Keyboard     X    X    X    X    X    X
LoRez (CGA)  X    X    X         X    X
HiRez        X    X    X    X
Mode Detect  X    X    X
Scoring      X    X    X
CongratWin   X    X    X
Full Decor.  X    X    X
Auto-Home    X    X    X
Circles      X    X
Auto-Finish  X    X
Savestate    X    X
Detect GRiD  X    X
Save/Load    X
Mouse        X


-------------==[ ON THIS DISK ]==-------------
 (the BUILDS directory contains all versions)

 TINYSOL.COM - TinySol Full (mouse support)
 TSOL3K.COM  - TinySol Medium, 3KB
