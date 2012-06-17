/* file tonepad.ck is responsible for adding the other source code files to the
 * virtual machine.  The main.ck file contains the main startup functionality
 * that should be run after importing all other files. */
Machine.add("console.ck");
Machine.add("osccontroller.ck");
Machine.add("gfxdriver.ck");
Machine.add("main.ck");
