9000 => int controllerPort; // incoming OSC port from TouchOSC

new GfxDriver @=> GfxDriver ui;
new OscController @=> OscController controller;

/*------------------------------------------------------------------------------
initialize and run
------------------------------------------------------------------------------*/
ui.init();
controller.init(controllerPort);

while(true) { 10::hour => now; }
