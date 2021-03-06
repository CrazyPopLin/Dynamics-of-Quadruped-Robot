%use Runge-Kutta to simulate the stand status

%There is dog have two legs and each one has two links, so the mass are
%double.


close all
clear all



global g m2 J2 m3 J3 m4 J4 m5 J5 m6 J6 M1 M2 M3 M4 M9 M10 M13
global L2 L3 L4 L5 L6
global M Bi Cq Qe gamma_i




%define time step
h=0.001;

%define number of time steps
imax=100;

%define masses and lengts
L2=0.24;
L3=0.21;
L4=0.65;
L5=0.21;
L6=0.24;
m2=2.5;
m3=1.25;
m4=57;
m5=1.25;
m6=2.5;
J2=0.0184;
J3=0.0046;
J4=2.12;
J5=0.0046;
J6=0.0184;

g=9.81;

%define initial conditions for independent variables

y(1,1)=0.5593;
y(2,1)=L4/2;
y(3,1)=5.7238;
y(4,1)=0;
y(5,1)=0;
y(6,1)=0;


%define initial conditions for dependent varibales
%link 2
yd(3,1)=2.4064;
yd(1,1)=(L2/2)*cos(yd(3,1));
yd(2,1)=(L2/2)*sin(yd(3,1));

%link 3
yd(4,1)=(L2)*cos(yd(3,1))+(L3/2)*cos(y(1,1));
yd(5,1)=(L2)*sin(yd(3,1))+(L3/2)*sin(y(1,1));

%link 4
yd(7,1)=0;
yd(6,1)=(L2)*sin(yd(3,1))+(L3)*sin(y(1,1))+(L4/2)*sin(yd(7,1));

%link 5
yd(8,1)=(L2)*cos(yd(3,1))+(L3)*cos(y(1,1))+L4*cos(yd(7,1))+(L5/2)*cos(y(3,1));
yd(9,1)=(L2)*sin(yd(3,1))+(L3)*sin(y(1,1))+L4*sin(yd(7,1))+(L5/2)*sin(y(3,1));

%link 6
yd(12,1)=3.8768;
yd(10,1)=(L2)*cos(yd(3,1))+(L3)*cos(y(1,1))+L4*cos(yd(7,1))+L5*cos(y(3,1))+(L6/2)*cos(yd(12,1));
yd(11,1)=(L2)*sin(yd(3,1))+(L3)*sin(y(1,1))+L4*sin(yd(7,1))+L5*sin(y(3,1))+(L6/2)*sin(yd(12,1));


M9=0;
M10=0;
M13=0;
%solve the differential equations

for i=1:imax
    t(i)=(i-1)*h;
    
    M1=-100*(yd(3,i)-y(1,i)-pi/6);
    M2=100*(yd(3,i)-y(1,i)-pi/6);
    M3=-100*(y(3,i)-yd(12,i)-pi/6);
    M4=100*(y(3,i)-yd(12,i)-pi/6);
    
    
   
    
    
    f1=h*FRRRRRR(y(:,i),yd(:,i),t(i));
    f2=h*FRRRRRR(y(:,i)+0.5*f1,yd(:,i),t(i)+0.5*h);
    f3=h*FRRRRRR(y(:,i)+0.5*f2,yd(:,i),t(i)+0.5*h);
    f4=h*FRRRRRR(y(:,i)+f3,yd(:,i),t(i)+h);
    y(:,i+1)=y(:,i)+(f1+2*f2+2*f3+f4)/6;
    
    %update dependent and indepent variables
    
    
    R2x=yd(1,i);
    R2y=yd(2,i);
    th2=yd(3,i);
    R3x=yd(4,i);
    R3y=yd(5,i);
    th3=y(1,i+1);
    R4x=y(2,i+1);
    R4y=yd(6,i);
    th4=yd(7,i); 
    R5x=yd(8,i);
    R5y=yd(9,i);
    th5=y(3,i+1);
    R6x=yd(10,i);
    R6y=yd(11,i);
    th6=yd(12,i);
    
    
    C=[R2x - (L2*cos(th2))/2;
       R2y - (L2*sin(th2))/2; 
       R2x - R3x + (L2*cos(th2))/2 + (L3*cos(th3))/2;
       R2y - R3y + (L2*sin(th2))/2 + (L3*sin(th3))/2;
       R3x - R4x + (L3*cos(th3))/2 + (L4*cos(th4))/2;
       R3y - R4y + (L3*sin(th3))/2 + (L4*sin(th4))/2;
       R4x - R5x + (L4*cos(th4))/2 + (L5*cos(th5))/2;
       R4y - R5y + (L4*sin(th4))/2 + (L5*sin(th5))/2;
       R5x - R6x + (L5*cos(th5))/2 + (L6*cos(th6))/2;
       R5y - R6y + (L5*sin(th5))/2 + (L6*sin(th6))/2;
       R6x + (L6*cos(th6))/2-L4;
       R6y + (L6*sin(th6))/2];
   
    %create the matrices that are generated by splitting the Jacobian according to dependent and independent matrices
 Cqi=[                0,  0,                0;
                      0,  0,                0;
       -(L3*sin(th3))/2,  0,                0;
        (L3*cos(th3))/2,  0,                0;
       -(L3*sin(th3))/2, -1,                0;
        (L3*cos(th3))/2,  0,                0;
                      0,  1, -(L5*sin(th5))/2;
                      0,  0,  (L5*cos(th5))/2;
                      0,  0, -(L5*sin(th5))/2;
                      0,  0,  (L5*cos(th5))/2;
                      0,  0,                0;
                     0,  0,                0];

    

Cqd=...
[ 1, 0,  (L2*sin(th2))/2,  0,  0,  0,                0,  0,  0,  0,  0,                0;
       0,1, -(L2*cos(th2))/2,  0,  0,  0,                0,  0,  0,  0,  0,                0;
       1,0, -(L2*sin(th2))/2, -1,  0,  0,                0,  0,  0,  0,  0,                0;
       0,1,  (L2*cos(th2))/2,  0, -1,  0,                0,  0,  0,  0,  0,                0;
       0,0,                0,  1,  0,  0, -(L4*sin(th4))/2,  0,  0,  0,  0,                0;
       0,0,                0,  0,  1, -1,  (L4*cos(th4))/2,  0,  0,  0,  0,                0;
       0,0,                0,  0,  0,  0, -(L4*sin(th4))/2, -1,  0,  0,  0,                0;
       0,0,                0,  0,  0,  1,  (L4*cos(th4))/2,  0, -1,  0,  0,                0;
       0,0,                0,  0,  0,  0,                0,  1,  0, -1,  0, -(L6*sin(th6))/2;
       0,0,                0,  0,  0,  0,                0,  0,  1,  0, -1,  (L6*cos(th6))/2;
       0,0,                0,  0,  0,  0,                0,  0,  0,  1,  0, -(L6*sin(th6))/2;
      0,0,                0,  0,  0,  0,                0,  0,  0,  0,  1,  (L6*cos(th6))/2];


    
    %Generate the new values of the dependent variables
yd(:,i+1)=-inv(Cqd)*(C+Cqi*(y(1:3,i+1)-y(1:3,i)))+yd(:,i);
    
    
end
t(i+1)=t(i)+h;


%calculate joint locations

xa=0;
ya=0;
xb=yd(1,:)+(L2/2)*cos(yd(3,:));
yb=yd(2,:)+(L2/2)*sin(yd(3,:));
xc=yd(4,:)+(L3/2)*cos(y(1,:));
yc=yd(5,:)+(L3/2)*sin(y(1,:));
xe=y(2,:)+(L4/2)*cos(yd(7,:));
ye=yd(6,:)+(L4/2)*sin(yd(7,:));
xf=yd(8,:)+(L5/2)*cos(y(3,:));
yf=yd(9,:)+(L5/2)*sin(y(3,:));




%plot the links
figure
for i=1:imax
    %generate the links at every instant
    u(1,i)=0;
    v(1,i)=0;
    u(2,i)=xb(i);
    v(2,i)=yb(i);
    u(3,i)=xc(i);
    v(3,i)=yc(i);
    u(4,i)=xe(i);
    v(4,i)=ye(i);
    u(5,i)=xf(i);
    v(5,i)=yf(i);
    u(6,i)=0.65;
    v(6,i)=0;
    
    
   if(i/4)-floor(i/4)==0
       plot(u(1:2,i),v(1:2,i),'b',u(2:3,i),v(2:3,i),'r',u(3:4,i),v(3:4,i),'g', u(4:5,i),v(4:5,i),'r',u(5:6,i),v(5:6,i),'b','LineWidth',2)
   end
    hold on
    
end

title('motion of th links')
axis equal
grid on


%disp(['x(2,i)=',num2str(x(2,i))])
