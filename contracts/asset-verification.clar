;; Asset Verification Contract
;; Validates energy generation equipment

(define-data-var admin principal tx-sender)

;; Asset types
(define-constant SOLAR u1)
(define-constant WIND u2)
(define-constant HYDRO u3)
(define-constant BATTERY u4)

;; Asset status
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_REJECTED u2)

;; Map to store asset information
(define-map assets
  { asset-id: uint }
  {
    owner: principal,
    asset-type: uint,
    capacity: uint,
    location: (string-utf8 100),
    status: uint,
    verification-date: uint
  }
)

;; Counter for asset IDs
(define-data-var asset-id-counter uint u0)

;; Register a new asset
(define-public (register-asset (asset-type uint) (capacity uint) (location (string-utf8 100)))
  (let
    (
      (new-id (+ (var-get asset-id-counter) u1))
    )
    (begin
      (var-set asset-id-counter new-id)
      (map-set assets
        { asset-id: new-id }
        {
          owner: tx-sender,
          asset-type: asset-type,
          capacity: capacity,
          location: location,
          status: STATUS_PENDING,
          verification-date: u0
        }
      )
      (ok new-id)
    )
  )
)

;; Verify an asset (admin only)
(define-public (verify-asset (asset-id uint))
  (let
    (
      (asset (unwrap! (map-get? assets { asset-id: asset-id }) (err u1)))
    )
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u403))
      (map-set assets
        { asset-id: asset-id }
        (merge asset {
          status: STATUS_VERIFIED,
          verification-date: block-height
        })
      )
      (ok true)
    )
  )
)

;; Reject an asset (admin only)
(define-public (reject-asset (asset-id uint))
  (let
    (
      (asset (unwrap! (map-get? assets { asset-id: asset-id }) (err u1)))
    )
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u403))
      (map-set assets
        { asset-id: asset-id }
        (merge asset {
          status: STATUS_REJECTED,
          verification-date: block-height
        })
      )
      (ok true)
    )
  )
)

;; Get asset details
(define-read-only (get-asset (asset-id uint))
  (map-get? assets { asset-id: asset-id })
)

;; Check if asset is verified - FIXED: now consistently returns a boolean
(define-read-only (is-asset-verified (asset-id uint))
  (match (map-get? assets { asset-id: asset-id })
    asset (is-eq (get status asset) STATUS_VERIFIED)
    false
  )
)

;; Transfer asset ownership
(define-public (transfer-asset (asset-id uint) (new-owner principal))
  (let
    (
      (asset (unwrap! (map-get? assets { asset-id: asset-id }) (err u1)))
    )
    (begin
      (asserts! (is-eq tx-sender (get owner asset)) (err u403))
      (map-set assets
        { asset-id: asset-id }
        (merge asset { owner: new-owner })
      )
      (ok true)
    )
  )
)

;; Change admin (admin only)
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (var-set admin new-admin)
    (ok true)
  )
)
