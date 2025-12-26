(define (problem p1)
    (:domain railwayd)

    (:objects
        t1 t2 - train
        p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 - railroad-point
        broad meter - rail-type
    )

    (:init
        ;; Connected roads
        (connected-road p0 p1)
        (connected-road p1 p0)
        (connected-road p1 p2)
        (connected-road p2 p1)
        (connected-road p3 p4)
        (connected-road p4 p3)
        (connected-road p4 p5)
        (connected-road p5 p4)
        (connected-road p5 p6)
        (connected-road p6 p5)
        (connected-road p1 p7)
        (connected-road p7 p1)
        (connected-road p0 p8)
        (connected-road p8 p0)
        (connected-road p1 p9)
        (connected-road p9 p1)

        ;; Not-connected roads
        (not-connected-road p4 p7)
        (not-connected-road p7 p4)

        ;; Accessible roads
        (accessible-road p0 p1)
        (accessible-road p1 p0)
        (accessible-road p1 p2)
        (accessible-road p2 p1)
        (accessible-road p3 p4)
        (accessible-road p4 p3)
        (accessible-road p4 p5)
        (accessible-road p5 p4)
        (accessible-road p5 p6)
        (accessible-road p6 p5)
        (accessible-road p1 p7)
        (accessible-road p7 p1)
        (accessible-road p4 p7)
        (accessible-road p7 p4)
        (accessible-road p0 p8)
        (accessible-road p8 p0)
        (accessible-road p1 p9)
        (accessible-road p9 p1)

        ;; Railroad types
        (railroad-type p0 p1 broad)
        (railroad-type p1 p0 broad)
        (railroad-type p1 p2 broad)
        (railroad-type p2 p1 broad)
        (railroad-type p3 p4 broad)
        (railroad-type p4 p3 broad)
        (railroad-type p4 p5 broad)
        (railroad-type p5 p4 broad)
        (railroad-type p5 p6 broad)
        (railroad-type p6 p5 broad)
        (railroad-type p1 p7 broad)
        (railroad-type p7 p1 broad)
        (railroad-type p1 p7 meter)
        (railroad-type p7 p1 meter)
        (railroad-type p4 p7 broad)
        (railroad-type p7 p4 broad)
        (railroad-type p4 p7 meter)
        (railroad-type p7 p4 meter)
        (railroad-type p0 p8 broad)
        (railroad-type p8 p0 broad)
        (railroad-type p0 p8 meter)
        (railroad-type p8 p0 meter)
        (railroad-type p1 p9 broad)
        (railroad-type p9 p1 broad)
        (railroad-type p1 p9 meter)
        (railroad-type p9 p1 meter)

        ;; Train types
        (train-type t1 broad)
        (train-type t2 broad)

        ;; Turnout points
        (turnout-point p7)

        ;; Turnout alternatives
        (alternative-points p7 p1 p4)
        (alternative-points p7 p4 p1)

        ;; Train locations
        (train-at t1 p0)
        (not-free-point p0)
        (train-at t2 p3)
        (not-free-point p3)

        ;; Free points
        (free-point p1)
        (free-point p2)
        (free-point p4)
        (free-point p5)
        (free-point p6)
        (free-point p7)
        (free-point p8)
        (free-point p9)

        ;; Not-blocked-track
        (not-blocked-track p0 p1)
        (not-blocked-track p1 p0)
        (not-blocked-track p1 p2)
        (not-blocked-track p2 p1)
        (not-blocked-track p3 p4)
        (not-blocked-track p4 p3)
        (not-blocked-track p4 p5)
        (not-blocked-track p5 p4)
        (not-blocked-track p5 p6)
        (not-blocked-track p6 p5)
        (not-blocked-track p1 p7)
        (not-blocked-track p7 p1)
        (not-blocked-track p4 p7)
        (not-blocked-track p7 p4)
        (not-blocked-track p0 p8)
        (not-blocked-track p8 p0)
        (not-blocked-track p1 p9)
        (not-blocked-track p9 p1)

        ;; Not-train-blocked-at
        (not-train-blocked-at t1 p0)
        (not-train-blocked-at t1 p1)
        (not-train-blocked-at t1 p2)
        (not-train-blocked-at t2 p3)
        (not-train-blocked-at t2 p4)
        (not-train-blocked-at t2 p5)
        (not-train-blocked-at t2 p6)

        ;; Boarding points
        (boarding-point t1 p1)
        (boarding-point t2 p4)

        ;; Train speeds
        (= (train-speed t1) 1.0)
        (= (train-speed t2) 1.0)

        ;; Road distances
        (= (road-distance p0 p1) 10)
        (= (road-distance p1 p0) 10)
        (= (road-distance p1 p2) 7)
        (= (road-distance p2 p1) 7)
        (= (road-distance p3 p4) 10)
        (= (road-distance p4 p3) 10)
        (= (road-distance p4 p5) 5)
        (= (road-distance p5 p4) 5)
        (= (road-distance p5 p6) 10)
        (= (road-distance p6 p5) 10)
        (= (road-distance p1 p7) 9)
        (= (road-distance p7 p1) 9)
        (= (road-distance p4 p7) 8)
        (= (road-distance p7 p4) 8)
        (= (road-distance p0 p8) 5)
        (= (road-distance p8 p0) 5)
        (= (road-distance p1 p9) 6)
        (= (road-distance p9 p1) 6)

        ;; Board times
        (= (board-time t1 p1) 1)
        (= (board-time t2 p4) 1)

        ;; Turnout time
        (= (turnout-time) 1)
    )

    (:goal (and
        (train-at t1 p2)
        (train-at t2 p6)
        (board-passengers t1 p1)
        (board-passengers t2 p4)
    ))

    (:metric minimize (total-time))
)