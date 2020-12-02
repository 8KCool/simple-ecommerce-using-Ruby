json.(license, :id, :key)
json.game license.game, partial: 'admin/v1/games/game', as: :game
json.user license.user, partial: 'admin/v1/users/user', as: :user