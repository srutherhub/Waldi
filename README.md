# **Waldi: Walking Distance**

**Waldi** is a map app. Users use this app to find points of interest (POIs) within walking distance.

## 🧍‍♀️ User Base

1. People who travel a lot  
2. People who live in cities or places with many nearby POIs

---

## ✅ Core User Actions (In Development Order)

- [x] Decide what walking distance means to them in minutes (15, 30, 45, 60)  
  - [x] **Change to distance instead of time**
- [x] Filter points of interest by category (Restaurants, Museums, Parks, etc)  
  - [x] Use `MKLocalSearch` with distance and elevation (if possible)
- [ ] Select a point of interest to view more information  
  - Ratings, comments, standard Maps integration
- [ ] View POIs in a list view and sort by:
  - Closeness, ratings, popularity, etc.
  - [ ] List view should scroll left and right
  - [ ] Selecting a POI should open the list view on that specific POI
- [ ] Save POIs to a list/collection  
  - Organize by location or city
- [ ] Wayfind to the point of interest

---

## 🌟 Features I Wish I Could Develop

1. Sharing a list of POIs with other users (via email or in-app)  
2. Authentication? (Is this needed?)

---

## 🐞 Issues

1. `SelectedMenuItem` should not be `nil` — causes a crash
