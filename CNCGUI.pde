import processing.serial.*;
import geomerative.*;
Serial arduino;
boolean arduinoConnected = true;
Simulator cnc;
boolean keymap[];
ArrayList<Command> toolpath;
svgParser parser;
String input;

void loadSVG(){
  selectInput("Select a file to process:", "svgFileSelected");
}

void svgFileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    if(selection.getAbsolutePath().indexOf(".svg")>0){ // check if the path ends in ".svg"
      println("SVG file selected!");
      parser = new svgParser(selection);
      toolpath = parser.getPath();
      /*for(int i = 1; i<toolpath.size(); i++){
      if(arduinoConnected)toolpath.get(i).sendCommand(arduino);
      toolpath.get(i).print();
      delay(100);
    }*/
    }else{
      println("not a SVG file selected");
    }
  }
}


  void setup(){
  size(768,512,P3D);
  RG.init(this);
  parser = new svgParser();
  cnc = new Simulator(arduino);//give it a port to arduino
  keymap = new boolean[4];//0,1,2,3 - left, right, up, down
  if(arduinoConnected)arduino = new Serial(this, "COM3", 9600); //on my computer the arduino creates the COM3 port
}

void draw(){
  /*if(arduinoConnected){
      while( arduino.available() > 0) 
    {  // If data is available,
    input = arduino.readString();         // read it and store it in val
    if(input!=null)println(input);
    } 
  }*/
  background(13,13,25);
  cnc.drawCNC();
  //cnc.printPosition();
  if(keymap[0]){cnc.stepMotor('y',1);}
  if(keymap[1]){cnc.stepMotor('y',-1);}
  if(keymap[2]){
    cnc.stepMotor('z',1);
  }
  if(keymap[3]){
    cnc.stepMotor('z', -1);
  }
}

void keyPressed(){
  if(key == 'p' && toolpath.size()>0 && arduinoConnected){
    for(int i = 1; i<toolpath.size(); i++){
      if(arduinoConnected)toolpath.get(i).sendCommand(arduino);
      toolpath.get(i).print();
      delay(70);
    }
  }
  if(key == CODED){
    switch(keyCode){
      case LEFT:
        keymap[0]=true;
        break;
      case RIGHT:
        keymap[1]=true;
        break;
      case UP:
        if(arduinoConnected){
          Command com = new Command((byte)'l',(byte)'u');
          com.print();
          com.sendCommand(arduino);
        }
        keymap[2]=true;
        break;
      case DOWN:
        if(arduinoConnected){
            Command com = new Command((byte)'l',(byte)'d');
            com.print();
            com.sendCommand(arduino);
          }
        keymap[3]=true;
        break;
    }
  }else if(key=='o'){
    loadSVG();
  }else if(key=='m'){
    
  }
}

void keyReleased(){
  if(key == CODED){
    switch(keyCode){
      case LEFT:
        keymap[0]=false;
        break;
      case RIGHT:
        keymap[1]=false;
        break;
      case UP:
        keymap[2]=false;
        break;
      case DOWN:
        keymap[3]=false;
        break;
    }
  }
}