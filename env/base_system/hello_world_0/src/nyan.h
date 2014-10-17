
#define INTRO \
SQR(D6s, EIGHT), \
SQR(E6, EIGHT), \
SQR(F6s, QUART), \
SQR(B6, QUART), \
SQR(D6s, EIGHT), \
SQR(E6, EIGHT), \
SQR(F6s, EIGHT), \
SQR(B6, EIGHT), \
SQR(C7s, EIGHT), \
SQR(D7s, EIGHT), \
SQR(C7s, EIGHT), \
SQR(A6s, EIGHT), \
SQR(B6, QUART), \
SQR(F6s, QUART), \
SQR(D6s, EIGHT), \
SQR(E6, EIGHT), \
SQR(F6s, QUART), \
SQR(B6, QUART), \
SQR(C7s, EIGHT), \
SQR(A6s, EIGHT), \
SQR(B6, EIGHT), \
SQR(C7s, EIGHT), \
SQR(E7, EIGHT), \
SQR(D7s, EIGHT), \
SQR(E7, EIGHT), \
SQR(C7s, EIGHT)

#define BAR1 \
SQR(G5s, QUART), \
SQR(A5s, QUART), \
SQR(D5s, EIGHT), \
SQR(D5s, EIGHT), \
REST(EIGHT), \
SQR(B4, EIGHT), \
SQR(D5, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
REST(EIGHT), \
SQR(B4, QUART), \
SQR(C5s, QUART)

#define BAR2 \
SQR(D5, QUART), \
SQR(D5, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(F5s, EIGHT), \
SQR(G5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(F5s, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT)

#define BAR3 \
SQR(D5s, QUART), \
SQR(F5s, QUART), \
SQR(G5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(F5s, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(D5, EIGHT), \
SQR(D5s, EIGHT), \
SQR(D5, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT)

#define BAR4 \
SQR(D5, QUART), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(F5s, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, QUART), \
SQR(B4, QUART), \
SQR(C5s, QUART)

#define BAR5 \
SQR(F5s, QUART), \
SQR(G5s, QUART), \
SQR(D5s, EIGHT), \
SQR(D5s, EIGHT), \
REST(EIGHT), \
SQR(B4, EIGHT), \
SQR(D5, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
REST(EIGHT), \
SQR(B4, QUART), \
SQR(C5s, QUART)

#define BAR6 \
SQR(B4, QUART), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, QUART), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(E5, EIGHT), \
SQR(D5s, EIGHT), \
SQR(E5, EIGHT), \
SQR(F5s, EIGHT)

#define BAR7 \
SQR(B4, QUART), \
SQR(B4, QUART), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, EIGHT), \
SQR(F4s, EIGHT), \
SQR(E5, EIGHT), \
SQR(D5s, EIGHT), \
SQR(C5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(F4s, EIGHT), \
SQR(D4s, EIGHT), \
SQR(E4, EIGHT), \
SQR(F4s, EIGHT)

#define BAR8 \
SQR(B4, QUART), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, QUART), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, EIGHT), \
SQR(B4, EIGHT), \
SQR(C5s, EIGHT), \
SQR(D5s, EIGHT), \
SQR(B4, EIGHT), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(F4s, EIGHT)

#define BAR9 \
SQR(B4, QUART), \
SQR(B4, EIGHT), \
SQR(A4s, EIGHT), \
SQR(B4, EIGHT), \
SQR(F4s, EIGHT), \
SQR(G4s, EIGHT), \
SQR(B4, EIGHT), \
SQR(E5, EIGHT), \
SQR(D5s, EIGHT), \
SQR(E5, EIGHT), \
SQR(F5s, EIGHT), \
SQR(B4, QUART), \
SQR(A4s, QUART)

sample_t nyan[] = {
INTRO,

BAR1,
BAR2,
BAR3,
BAR4,

LOOP,

BAR5,
BAR2,
BAR3,
BAR4,

BAR6,
BAR7,
BAR8,
BAR9,

BAR6,
BAR7,
BAR8,
BAR9,

BAR5,
BAR2,
BAR3,
BAR4
};