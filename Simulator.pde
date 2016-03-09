class Simulator{
  
  boolean arduinoConnected;
  private Serial arduino;
  
  public float xPosition;
  public float yPosition;
  public float zPosition;
  
  
  private PShape cncBody;
  private PShape xSlider;
  private PShape ySlider;
  private PShape zSlider;
  private PShape nema17;
  private PShape shaft;
  
  
  //real measurements
  private int feedRate = 100; //how many miliseconds does it take to move one step
  //private float stepsPerSec = 600;
  private float rotationPerStep = 1.8; //in degrees
  private float distancePerDegree = 1.f/12.f; //in centimeters
  private float xMax = 52; //distances in cm
  private float yMax = 47;//47
  private float zMax = 30;//30
  private float xRotation = 0;
  private float yRotation = 0;
  private float zRotation = 0;
  
  
  //model distances
  private float modelxMax = 8; //arbitrary numbers i measured on the models
  private float modelyMax = 10.3; //being the range that the sliders can travel
  private float modelzMax = 3.5;
  
  public Simulator(Serial arduino){
    if(arduino == null)arduinoConnected = false;
    else{
    this.arduino = arduino;
    arduinoConnected = true;
    }
    cncBody = loadShape("Models/MainBody.obj");
    xSlider = loadShape("Models/XSlider.obj");
    ySlider = loadShape("Models/YSlider.obj");
    zSlider = loadShape("Models/ZSlider.obj");
    nema17 = loadShape("Models/Nema17.obj");
    shaft = loadShape("Models/Shaft.obj");
    
    xPosition = 0;
    yPosition = 0;
    zPosition = 0;
  }

  
  private void cncView(){ //helper function to position objects
    float fov = PI/3.0;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    perspective(fov, float(width)/float(height), 
                cameraZ/10.0, cameraZ*10.0);
    translate(width/2,height*8/11,0);// magic nubers for positioning
    scale(17);
    rotateZ(PI);
    rotateY(-PI/2);
  }
  
  public void drawCNC(){
    stroke(255);
    lights();
    pushMatrix();
      cncView();
      shape(cncBody);
    popMatrix();
    
    pushMatrix();
      cncView();
      positionSlider('x');
      shape(xSlider);
    popMatrix();
    
    pushMatrix();
      cncView();
      positionSlider('y');
      shape(ySlider);
    popMatrix();
    
    pushMatrix();
      cncView();
      positionSlider('z');
      shape(zSlider);
    popMatrix();
  }
  
  private void positionSlider(char axis){
    if(axis == 'x'){
      translate(xPosition * modelxMax / xMax - modelxMax/2.f,0,0);
    }else if(axis == 'y'){
      translate(0,0,yPosition * modelyMax / yMax - modelyMax/2.f);
    }else if(axis == 'z'){
      translate(0,0,yPosition * modelyMax / yMax - modelyMax/2.f);
      translate(0,zPosition * modelzMax / zMax,0);
    }
  }
  
  public void stepMotor(char axis, int steps){
    String positive = "0";
    if(steps>0){
    positive = "1";
    }
    while(abs(steps)>0){
    float degreesToRotate = rotationPerStep*steps;
    if(axis == 'x'){// x axis
        if(xPosition + degreesToRotate * distancePerDegree>xMax || xPosition + degreesToRotate * distancePerDegree<0)break;
        xRotation = xRotation + degreesToRotate;
        xPosition = xPosition + degreesToRotate * distancePerDegree;
    }else if(axis == 'y'){// y axis
        if(yPosition + degreesToRotate * distancePerDegree>yMax || yPosition + degreesToRotate * distancePerDegree<0)break;
        yRotation = yRotation + degreesToRotate;
        yPosition = yPosition + degreesToRotate * distancePerDegree;
    }else if(axis == 'z'){// z axis
        if(zPosition + degreesToRotate * distancePerDegree>zMax || zPosition + degreesToRotate * distancePerDegree<0)break;
        zRotation = zRotation + degreesToRotate;
        zPosition = zPosition + degreesToRotate * distancePerDegree;
        //arduino.write("z"+positive);
    }else{
      println("Unfamiliar axis given!");
    }
    delay(feedRate);
    if(steps>0)steps--;
    else steps++;
    }
  }
  
  public void printPosition(){
    println("Position: x="+xPosition+" y="+yPosition+" z="+zPosition);
  }
  
  public void sendCommands(ArrayList<Command> comms, Serial arduino){
    if(arduino==null)println("serial unavailable!");
    for(int i = 0; i<comms.size(); i++){
      if(arduinoConnected)comms.get(i).sendCommand(arduino);
      comms.get(i).print();
      delay(500);
    }
  }
  
  
}