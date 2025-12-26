;; ============================================================================
;; Railway Temporal Planning Domain (Simplified)
;; Compatible with: TFD (Temporal Fast Downward), OPTIC, POPF2
;; 
;; Metric: minimize (total-time) - supported by all three planners
;; 
;; Features:
;; - Simple train movement
;; - Turnout operations for parallel tracks
;; - Block track and block train disruptions only
;; - Passenger boarding at specific points
;; ============================================================================

(define (domain railwayd)
    (:requirements :strips :typing :numeric-fluents :durative-actions)

    (:types
        railroad-point
        train 
        rail-type
    )

    (:predicates
        ;; Location predicates
        (train-at ?tr - train ?at - railroad-point)
        
        ;; Track connectivity
        (connected-road ?from - railroad-point ?to - railroad-point)
        (not-connected-road ?from - railroad-point ?to - railroad-point)
        (accessible-road ?from - railroad-point ?to - railroad-point)
        
        ;; Point availability
        (free-point ?at - railroad-point)
        (not-free-point ?at - railroad-point)
        
        ;; Turnout points (each turnout connects to exactly 2 alternatives)
        (turnout-point ?at - railroad-point)
        (alternative-points ?at - railroad-point ?alt1 - railroad-point ?alt2 - railroad-point)
        
        ;; Gauge type compatibility
        (train-type ?tr - train ?rtype - rail-type)
        (railroad-type ?from - railroad-point ?to - railroad-point ?rtype - rail-type)
        
        ;; Disruption predicates
        (blocked-track ?from - railroad-point ?to - railroad-point)
        (not-blocked-track ?from - railroad-point ?to - railroad-point)
        (train-blocked-at ?tr - train ?at - railroad-point)
        (not-train-blocked-at ?tr - train ?at - railroad-point)
        
        ;; Boarding
        (boarding-point ?tr - train ?at - railroad-point)
        (board-passengers ?tr - train ?at - railroad-point)
    )

    (:functions
        (road-distance ?from - railroad-point ?to - railroad-point)
        (train-speed ?tr - train)
        (clear-track-time ?from - railroad-point ?to - railroad-point)
        (train-blockage-time ?tr - train ?at - railroad-point)
        (turnout-time)
        (board-time ?tr - train ?at - railroad-point)
    )

    ;; ========================================================================
    ;; TRAIN MOVEMENT ACTION
    ;; ========================================================================
    
    (:durative-action drive-train
        :parameters (?tr - train ?from - railroad-point ?to - railroad-point ?rtype - rail-type)
        :duration (= ?duration (/ (road-distance ?from ?to) (train-speed ?tr)))
        :condition (and 
            (at start (train-at ?tr ?from))
            (at start (free-point ?to))
            (at start (train-type ?tr ?rtype))
            (at start (railroad-type ?from ?to ?rtype))
            (at start (not-train-blocked-at ?tr ?from))
            (at start (not-blocked-track ?from ?to))
            (at start (accessible-road ?from ?to))
            
            (over all (connected-road ?from ?to))
            (over all (free-point ?to))
        )
        :effect (and 
            (at start (not (train-at ?tr ?from)))
            (at start (free-point ?from))
            (at start (not (not-free-point ?from)))
            (at start (not (accessible-road ?from ?to)))
            (at start (not (accessible-road ?to ?from)))
            
            (at end (train-at ?tr ?to))
            (at end (not (free-point ?to)))
            (at end (not-free-point ?to))
            (at end (accessible-road ?from ?to))
            (at end (accessible-road ?to ?from))
        )
    )
    
    ;; ========================================================================
    ;; DISRUPTION RESOLUTION ACTIONS
    ;; ========================================================================

    (:durative-action solve-train-blockage
        :parameters (?tr - train ?at - railroad-point)
        :duration (= ?duration (train-blockage-time ?tr ?at))
        :condition (and 
            (at start (train-blocked-at ?tr ?at))
            (over all (train-at ?tr ?at))
            (over all (train-blocked-at ?tr ?at))
        )
        :effect (and 
            (at end (not (train-blocked-at ?tr ?at)))
            (at end (not-train-blocked-at ?tr ?at))
        )
    )
    
    (:durative-action clear-track
        :parameters (?from - railroad-point ?to - railroad-point)
        :duration (= ?duration (clear-track-time ?from ?to))
        :condition (and 
            (at start (blocked-track ?from ?to))
            (over all (blocked-track ?from ?to))
        )
        :effect (and 
            (at end (not (blocked-track ?from ?to)))
            (at end (not (blocked-track ?to ?from)))
            (at end (not-blocked-track ?from ?to))
            (at end (not-blocked-track ?to ?from))
        )
    )
    
    ;; ========================================================================
    ;; PASSENGER BOARDING ACTION
    ;; ========================================================================

    (:durative-action board-passenger
        :parameters (?tr - train ?at - railroad-point)
        :duration (= ?duration (board-time ?tr ?at))
        :condition (and 
            (at start (train-at ?tr ?at))
            (over all (train-at ?tr ?at))
            (over all (boarding-point ?tr ?at))
        )
        :effect (and 
            (at end (board-passengers ?tr ?at))
        )
    )

    ;; ========================================================================
    ;; TURNOUT OPERATION ACTION
    ;; Each turnout connects exactly 2 alternative paths
    ;; ========================================================================

    (:durative-action turnout
        :parameters (?tp - railroad-point ?alt1 - railroad-point ?alt2 - railroad-point)
        :duration (= ?duration (turnout-time))
        :condition (and 
            (at start (connected-road ?tp ?alt1))
            (at start (not-connected-road ?tp ?alt2))
            (at start (turnout-point ?tp))
            (at start (alternative-points ?tp ?alt1 ?alt2))
        )
        :effect (and 
            (at start (not (connected-road ?tp ?alt1)))
            (at start (not (connected-road ?alt1 ?tp)))
            (at start (not-connected-road ?tp ?alt1))
            (at start (not-connected-road ?alt1 ?tp))
            (at end (connected-road ?tp ?alt2))
            (at end (connected-road ?alt2 ?tp))
            (at end (not (not-connected-road ?tp ?alt2)))
            (at end (not (not-connected-road ?alt2 ?tp)))
        )
    ) 
)
