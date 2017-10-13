
const company_class   = 'ar.com.goliath.Company',
      corporate_class = 'ar.com.goliath.corporate.CorporateUser',
      real_user_class = 'ar.com.goliath.RealUser'
      operation_pending_class = 'ar.com.operation.OperationPending',
      temporal_favorites_class = 'ar.com.favorites.TemporalFavorites';

module.exports.getUserCompanyClazz = () => company_class;

module.exports.getUserCorporateClazz = () => corporate_class;

module.exports.isUserCorporate = (clazz) => clazz === corporate_class;

module.exports.isRealUser = (clazz) => clazz === real_user_class;

module.exports.getOperationPendingClass = () => operation_pending_class;

module.exports.getTemporalFavoritesClass = () => temporal_favorites_class;