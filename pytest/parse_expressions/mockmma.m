(*
This file is adapted from Mockmma's README.txt.

Commented-out entries indicate things that still need to be done.

 *)
PrimeQ[23];  (* Sympy only *)
2+3 == 5;
3^7 == 2187;
4! == 24;
yy=5;
yy^2 == 25;

Sin[1.0];  (* Numpy messes up on decimal.Decimal *)

5+1.0 == 6;

2.3+5.63 (* != 7.93; due to approximate numbers *)

(* Don't handle := yet
g[x_]:=x^3
g[2]
Map[g, {1,2,3}]=={1,8,27}
 *)

Sqrt[4] == 2;

Sqrt[3.0];  (* Sqrt[3.0] * Sqrt[3.0] != 3.0; due to approximate numbers *)

{1,4,9,16}[[3]] == 9;

(* Sine and Cosine *)
Cos[0] == 1.0;
Sin[0] == 0.0;
Cos[Pi] == -1.0;
Sin[Pi]; (* != 0 due to approximate numbers *)
Sin[Pi/2] == 1.0;
Cos[Pi/2]; (* != 0 due to appproximate numbers *)
ArcSin[1]==Pi /2;

(* Comparisons *)
1>2 == True;
2<1 == False;
2>2 == False;
1<2 == True;
2<=1 == False;
1>=2 == False;
2>=2 == True;
2<=2 == True;
2<=2 == True;

(* Logical operators
True && True;
True && False;
True || False;
False || False;
*)

Log[E] == 1.0;

E==Exp[1] == True;
I*I;

(* Factoring *)
FactorInteger[24]=={{2, 3}, {3, 1}};
Expand[(1+x)^2]==1+2*x+x^2;
Factor[x^2+2*x+1]==(x+1)^2;

(* Derivatives and Integration *)
(*
D[Log[x],x]==1/x;
D[Sin[x],x]==Cos[x];
D[Cos[x],x]==-Sin[x];
Integrate[x,x]==x^2 / 2;
Integrate[Sin[z]*z,z]== - z Cos[z] + Sin[z];
Integrate[x,{x,0,1}]==1/2;
*)

(******************************************
The below we haven't gone over
 ******************************************)
(*
{a,b}.{c,d}==a*c + b * d;
{2,3}.{5,3}

If[True,a,b]==a;
If[False,a,b]==b;
If[False,a,b]==b

Abs[1]
Abs[-1]
Round[1.1]
Round[1.6]
Mod[13,3]
Mod[27,8]
Max[27,8]
Min[27,8]
Sign[27]
Sign[0]
Sign[-23]
Re[5+ 7 I]
Im[5+ 7 I]
Conjugate[5+ 7 I]==5 - 7 I
Floor[12.5]
Ceiling[12.5]
GCD[12,18]
LCM[12,18]
KroneckerDelta[12,18]
KroneckerDelta[a,a]
Table[1,{3}]=={1, 1,1}
Table[i^2,{i,1,10}]=={1, 4, 9, 16, 25, 36, 49, 64, 81, 100}
Table[i^2,{i,10}]=={1, 4, 9, 16, 25, 36, 49, 64, 81, 100}
Table[f[i], {i, 1, 3}]=={f[1],f[2],f[3]}
Module[{i=0},Table[i++,{10}]]=={1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
Table[10*i + j, {i, 4},{j,3}]==Out[2]:= {{11, 12, 13}, {21, 22, 23}, {31, 32, 33}, {41, 42, 43}}
Table[100* i + 10* j + k, {i, 3}, {j, 2}, {k, 4}]=
{{111, 112, 113, 114}, {121, 122, 123, 124}}, {{211, 212, 213, 214}, {221, 222, 223, 224}}, {{311, 312, 313, 314}, {321, 322, 323, 324}}}
Table[x^2, {x, {1, 4, 9, 16}}]=={1, 16, 81, 256}
Table[j^i, {i, {1, 2, 4}}, {j, {1, 4, 9}}]=={{1, 4, 9}, {1, 16, 81}, {1, 256, 6561}}
Take[{a,b,c,d,e,f},4]=={a,b,c,d}
Take[{a,b,c,d,e,f},-3]=={d,e,f}
Take[{a,b,c,d,e,f},{2,4}]=={b,c,d}
Take[{a,b,c,d,e,f},{2,-2}]=={b,c,d,e}
Take[{{11,12,13},{21,22,23},{31,32,33}},2]=={{11,12,13},{21,22,23}}
Take[{{11,12,13},{21,22,23},{31,32,33}},3,2]=={{11, 12}, {21, 22}, {31, 32}}
Take[{{11,12,13},{21,22,23},{31,32,33}},2,-1]=={{13}, {23}}
Take[Partition[Range[11,55],5],{2,4},{3,5}]=={{18, 19, 20}, {23, 24, 25}, {28, 29, 30}}
Partition[{a,b,c,d,e,f},2]=={{a, b}, {c, d}, {e, f}}
Partition[{a,b,c,d,e,f},3,1]=={{a, b, c}, {c, d, e}}
Fold[f,x,{a,b,c,d}]==f[f[f[f[x, a], b], c], d]
Fold[Times,1,{a,b,c,d}]==a b c d
Apply[f,{x}]==f[x]
Apply[Plus,{x,y,z}]== x + y + z
Apply[#1+#2&,{x,y}]==x+y
Fold[ x * #1 + #2 &, 0, {a, b, c, d, e}]==e + x (d + x (c + x (b + a x)))
Reverse[{a,b,c,d}]=={d, c, b, a}
Fold[1/(#1 + #2)&, x, Reverse[{a, b, c, d}]]==1/(1/(1/(1/(x+d)+c)+b)+a)
Fold[ 10*#1 + #2&, 0, {4, 5, 1, 6, 7, 8}]
Fold[#2-#1&, 0, Reverse[{a, b, c, d, e}]]==a - b + c - d + e
Fold[ {#2,#1}&, x, {a, b, c, d}]=={d, {c, {b, {a, x}}}}
Fold[Apply[#2,{#1}]&, x, {a,b,c,d}]==d[c[b[a[x]]]]
Fold[f[#]& , x, Range[5]]==f[f[f[f[f[x]]]]]
Union[{1,2},{3,4}]=={1, 2, 3, 4}
Join[{a,b,c},{x,y},{u,v,w}]=={a, b, c, x, y, u, v, w}
Join[{{a, b}, {c, d}}, {{1, 2}, {3, 4}}]=={{a, b}, {c, d}, {1, 2}, {3, 4}}
Union[{1, 2, 1, 3, 6, 2, 2}]=={1, 2, 3, 6}
Union[{a, b, a, c}, {d, a, e, b}, {c, a}]=={a, b, c, d, e}
Prepend[{a, b, c, d}, x]=={x, a, b, c, d}
Append[{a, b, c, d}, x]=={a, b, c, d, x}
Riffle[{a,b,c},{x,y,z}]=={a, x, b, y, c, z}
Fold[Union[#1, #1 + #2]&, {0}, {1, 2, 2, 8}]=={0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13}
FoldList[f,x,{a,b,c,d}]=={x, f[x, a], f[f[x, a], b], f[f[f[x, a], b], c], f[f[f[f[x, a], b], c], d]}
FoldList[Plus,0,{a,b,c,d}]=={0, a, a + b, a + b + c, a + b + c + d}
FoldList[#1^#2&,x,{a,b,c,d}]=={x, x^a , (x^a )^b , ((x^a )^b )^c , (((x^a )^b )^c )^d }
FoldList[#1*#2&,x,{a,b,c,d}]=={x, a x, a b x, a b c x, a b c d x}
FoldList[Times,1,Range[10]]=={1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800}
FoldList[1/(#2 + #1)&, x, Reverse[{a, b, c}]]==Out[5]:= {x, (c + x)^-1  , (b + (c + x)^-1  )^-1  , (a + (b + (c + x)^-1  )^-1  )^-1  }
Nest[f,x,3]==f[f[f[x]]]
Nest[(1 + #)^2& , 1, 3]==676
Nest[(1 + #)^2& , x, 5]==(1 + (1 + (1 + (1 + (1 + x)^2 )^2 )^2 )^2 )^2
Nest[Sqrt,100.0,4]==1.333521432163324
Range[4]=={1, 2, 3, 4}
Range[x,x+4]=={x, 1 + x, 2 + x, 3 + x, 4 + x}
IntegerDigits[58127]=={5, 8, 1, 2, 7}
IntegerDigits[58127,2]=={1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1}
IntegerDigits[58127,16]=={14, 3, 0, 15}
IntegerDigits[{6,7,2},2]=={{1, 1, 0}, {1, 1, 1}, {1, 0}}
IntegerDigits[7,{2,3,4}]=={{1, 1, 1}, {2, 1}, {1, 3}}
IntegerDigits[Range[0,7],2]=={{0}, {1}, {1, 0}, {1, 1}, {1, 0, 0}, {1, 0, 1}, {1, 1, 0}, {1, 1, 1}}
IntegerDigits[Range[0,7],2,3]=={{0, 0, 0}, {0, 0, 1}, {0, 1, 0}, {0, 1, 1}, {1, 0, 0}, {1, 0, 1}, {1, 1, 0}, {1, 1, 1}}
FromDigits[{5, 1, 2, 8}]==5128
FromDigits[{1, 0, 1, 1, 0, 1, 1}, 2]==91
FromDigits[{a, b, c, d, e}, x]==e + d x + c x^2 + b x^3  + a x^4
FromDigits[{7, 11, 0, 0, 0, 122}]==810122
Chop[10^-20]==0
Chop[a]==a
Chop[ 1 + 10.^-20* I - 7*(a + 10.^-30* b)*I]==1 - 7 I a
Chop[10^-17]==0
Chop[-1]==-1
Chop[-10.^-17]==0
Chop[{1,10^-20}]=={1, 0}
Chop[{10^-20,{1,10^-17}}]=={0, {1, 0}}
Chop[1+I]==1+I
Chop[1+10.^-20 I]==1
Chop[10^-20 +I]==I
Dimensions[{{a, b, c}, {d, e, f}}]=={2, 3}
Dimensions[f[f[x, y], f[a, b], f[s, t]]]=={3, 2}
Dimensions[f[g[x, y], g[a, b], g[s, t]]]=={3, 2}
Most[Range[10]]=={1, 2, 3, 4, 5, 6, 7, 8, 9}
Dimensions[{{a, b, c}, {d, e, f}}]=={2, 3}
Det[{{1,2,3},{4,5,6},{7,8,9}}]==0
Transpose[{{1,2,3},{4,5,6},{7,8,9}}]=={{1, 4, 7}, {2, 5, 8}, {3, 6, 9}}
Det[ {{a,b},{c,d}}]== -(1 b c) + a d
Tr[{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}]==15
MatrixRank[{{1,2,3},{4,5,6},{7,8,9}}]==2
MatrixRank[{{a,b},{2*a,2*b}}]==1
MatrixRank[{{1,I},{I,-1}}]==1
Eigenvalues[ { {1,0,0}, {0,1,0}, {0,0,1}}]== {1, 1, 1}
DiagonalMatrix[{a,b,c}]=={{a, 0, 0}, {0, b, 0}, {0, 0, c}}
DiagonalMatrix[{a,b,c},1]=={{0, a, 0, 0}, {0, 0, b, 0}, {0, 0, 0, c}, {0, 0, 0, 0}}
DiagonalMatrix[{a,b,c},-1]=={{0, 0, 0, 0}, {a, 0, 0, 0}, {0, b, 0, 0}, {0, 0, c, 0}}
DiagonalMatrix[{a,b,c},2]=={{0, 0, a, 0, 0}, {0, 0, 0, b, 0}, {0, 0, 0, 0, c}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}}
Nest[Times,2,10]==2
Table[f[i], {i, 10, -5, -2}]=={f[10], f[8], f[6], f[4], f[2], f[0], f[-2], f[-4]}
Dimensions[Table[100* i + 10* j + k, {i, 3}, {j, 2}, {k, 4}]]== {3, 2, 4}
Partition[{1,2,3,4,5,6,7,8,9,10},2]=={{1, 2}, {3, 4}, {5, 6}, {7, 8}, {9, 10}}
Partition[{1,2,3,4,5,6,7,8,9,10},2,1]=={{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 7}, {7, 8}, {8, 9}, {9, 10}}
Range[10,3]=={}
Range[3,10,2]== {3, 5, 7, 9}
Range[n,x+4]==Range[n, 4 + x]
Range[10,3,-1]=={10, 9, 8, 7, 6, 5, 4, 3}
Range[x,x+4]=={x, 1 + x, 2 + x, 3 + x, 4 + x}
Range[x+4,x]=={}
Range[x+4,x,-1]=={4 + x, 3 + x, 2 + x, 1 + x, x}
IntegerDigits[0]=={0}
Union[{a,b,c}]=={a, b, c}
Union[g[a,b,c],g[c,d,e]]==g[a, b, c, d, e]
Intersection[g[a,b,c],g[c,d,e]]==g[c]
Subsets[{a,b,c,d}]=={{},{a}, {a, b}, {a, b, c}, {a, b, c, d}, {a, b, d}, {a, c}, {a, c, d}, {a, d}, {b}, {b, c}, {b, c, d}, {b, d}, {c}, {c, d}, {d}}
Subsets[f[a,b,c,d]]==Out[12]:= {f[],f[a], f[a, b], f[a, b, c], f[a, b, c, d], f[a, b, d], f[a, c], f[a, c, d], f[a, d], f[b], f[b, c], f[b, c, d], f[b, d], f[c], f[c, d], f[d]}
AtomQ[x]==True
AtomQ[123456]==True
AtomQ[1/10]==True
AtomQ[3+I]==True
Nest[h,x,3]==h[h[h[x]]]
NestList[h,x,3]=={h[x], h[h[x]], h[h[h[x]]]}
Fold[h,x,{a,b,c}]==h[h[h[x, a], b], c]
FoldList[h,x,{a,b,c}]=={x, h[x, a], h[h[x, a], b], h[h[h[x, a], b], c]}
Length[{a,b,c,d}]==4
Length[a+b+c+d]==4
Length[f[g[x,y],z]]==2
Length[x]==0
Length[123456]==0
Length[3+I]==0
Length[1/10]==0
Length[{{a,b,c},{d,e,f}}]==2
Length[IntegerDigits[1000!]]==2568
Csc[Pi/2]==1
Cot[1.0]==0.64209261593433065
ArcCosh[2.0]==1.3169578969248166
Module[{x=5},x]
i=7
i++
i--
PermutationQ[e_List] := (Sort[e] === Range[Length[e]])
PermutationQ[{3,2,1}]
PermutationQ[{3,2,2}]
(p={2,3,4,5,1
Select[Range[20], PrimeQ[#]&]=={2, 3, 5, 7, 11, 13, 17, 19}
BesselJ[2,0.2]==0.004983354152783565
BesselY[2,0.2]==-32.15714455874636
BesselI[2,0.2]==0.0050166875138946783
BesselK[2,0.2]==49.51242928773285
Gamma[0.2]==4.5908437119988044
Plot[x^2,{x,-5,5}]
Plot3D[x^2+y^2,{x,-5,5},{y,-5,5}]
ParametricPlot[{Cos[t],Sin[t]},{t,0, 2 Pi}]
ListPlot[Table[{Cos[t],Sin[t]},{t,0,6.28,0.1}]]
ContourPlot[ Exp[-(x^2 + 3 y^2)], {x, -2, 2}, {y, -2, 2} ]
Erf[1.0]
Erfc[1.0]
LaplaceTransform[t,t,s]==1/s^2
InverseLaplaceTransform[1/s^2,s,t]==t
UnitStep[0.00001]
UnitStep[0]
Inverse[{{1,2},{3,4}}]=={{-2, 1}, {3/2, -1/2}}
Eigenvalues[{{1,2},{2,1}}]=={3, -1}
PartitionsP[1000]==24061467864032622473692149727991
LegendreQ[1,3]==1/2 (-2 +3  Log[-2])
 *)
