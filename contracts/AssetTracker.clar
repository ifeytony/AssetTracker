;; AssetTracker - a decentralized asset ownership tracking system
;; Constants for error codes
(define-constant ERR-ALREADY-CLAIMED u100)
(define-constant ERR-NOT-FOUND u101)
(define-constant ERR-INVALID-ASSET u102)
(define-constant ERR-NOT-OWNER u103)

;; Define a map to store asset ownership information
(define-map asset-registry
  {asset-hash: (buff 32)}  ;; Key: Asset hash
  {holder: principal})     ;; Value: Asset holder principal

;; Define a map to track assets owned by each entity
(define-map entity-assets
  {entity: principal}
  {asset-count: uint})

;; Public function to claim a new asset
(define-public (claim-asset (asset-hash (buff 32)))
  (let ((entity tx-sender))
    (if (<= (len asset-hash) u32)
        (if (is-some (map-get? asset-registry {asset-hash: asset-hash}))
            (err ERR-ALREADY-CLAIMED)
            (begin
              (map-set asset-registry {asset-hash: asset-hash} {holder: entity})
              (map-set entity-assets {entity: entity} 
                {asset-count: (+ u1 (default-to u0 (get asset-count (map-get? entity-assets {entity: entity}))))})
              (ok true)))
        (err ERR-INVALID-ASSET))))

;; Public function to check if an asset is registered
(define-public (is-asset-registered (asset-hash (buff 32)))
  (ok (is-some (map-get? asset-registry {asset-hash: asset-hash}))))

;; Public function to get the holder of a registered asset
(define-public (get-asset-holder (asset-hash (buff 32)))
  (match (map-get? asset-registry {asset-hash: asset-hash})
    registration (ok (get holder registration))
    (err ERR-NOT-FOUND)))

;; Public function to transfer asset ownership
(define-public (transfer-asset (asset-hash (buff 32)) (new-holder principal))
  (let 
    (
      (entity tx-sender)
      (current-holder-assets (get asset-count (default-to {asset-count: u0} (map-get? entity-assets {entity: entity}))))
    )
    (if (and 
          (<= (len asset-hash) u32) 
          (is-some (map-get? asset-registry {asset-hash: asset-hash}))
          (not (is-eq new-holder entity))
        )
        (match (map-get? asset-registry {asset-hash: asset-hash})
          registration 
            (if (is-eq (get holder registration) entity)
                (begin
                  (map-set asset-registry {asset-hash: asset-hash} {holder: new-holder})
                  (map-set entity-assets {entity: entity} 
                    {asset-count: (- current-holder-assets u1)})
                  (map-set entity-assets {entity: new-holder} 
                    {asset-count: (+ u1 (default-to u0 (get asset-count (map-get? entity-assets {entity: new-holder}))))})
                  (ok true))
                (err ERR-NOT-OWNER))
          (err ERR-NOT-FOUND))
        (err ERR-INVALID-ASSET))))

;; Public function to release an asset
(define-public (release-asset (asset-hash (buff 32)))
  (let ((entity tx-sender))
    (if (<= (len asset-hash) u32)
        (match (map-get? asset-registry {asset-hash: asset-hash})
          registration 
            (if (is-eq (get holder registration) entity)
                (begin
                  (map-delete asset-registry {asset-hash: asset-hash})
                  (map-set entity-assets {entity: entity} 
                    {asset-count: (- (default-to u0 (get asset-count (map-get? entity-assets {entity: entity}))) u1)})
                  (ok true))
                (err ERR-NOT-OWNER))
          (err ERR-NOT-FOUND))
        (err ERR-INVALID-ASSET))))

;; Public function to get the number of assets owned by an entity
(define-public (get-entity-asset-count (entity principal))
  (ok (default-to u0 (get asset-count (map-get? entity-assets {entity: entity})))))

;; Public function to check if an entity owns any assets
(define-public (entity-has-assets (entity principal))
  (ok (> (default-to u0 (get asset-count (map-get? entity-assets {entity: entity}))) u0)))