import { ComponentLoader } from 'adminjs'

const componentLoader = new ComponentLoader()

export const customComponents = {
  SettingsEditPage: componentLoader.add('SettingsEditPage', './components/settings/edit-page'),
  AllCategoriesSelect: componentLoader.add(
    'AllCategoriesSelect',
    './components/categories/all-parents-select'
  ),
  ParentCategoryNameWithLabel: componentLoader.add(
    'ParentCategoryNameWithLabel',
    './components/categories/parent-category-with-label'
  ),
  CustomCategorySelect: componentLoader.add(
    'CustomCategorySelect',
    './components/categories/parent-category-select'
  ),
  ParentCategoryName: componentLoader.add(
    'ParentCategoryName',
    './components/categories/parent-category-name'
  ),
  SimpleInput: componentLoader.add('SimpleInput', './components/common/input'),
  TranslatedValue: componentLoader.add('TranslatedValue', './components/common/translated-value'),
  JsonbField: componentLoader.add('JsonbField', './components/common/jsonb'),
  JsonbFieldList: componentLoader.add('JsonbFieldList', './components/common/jsonb-list'),
  CustomAction: componentLoader.add('CustomAction', './components/custom-action'),
  EditTextarea: componentLoader.add('EditTextarea', './components/common/edit-textarea'),
  CustomCategoryIconList: componentLoader.add(
    'CustomCategoryIconList',
    './components/categories/custom-icon-list'
  ),
  AccountAvatar: componentLoader.add('AccountAvatar', './components/accounts/avatar'),
  AssetImage: componentLoader.add('AssetImage', './components/assets/image'),
  AssetSize: componentLoader.add('AssetSize', './components/assets/size'),
  AssetDropzone: componentLoader.add('AssetDropzone', './components/assets/dropzone'),
  AuctionCategoryCard: componentLoader.add(
    'AuctionCategoryCard',
    './components/auctions/category-card'
  ),
  AuctionAssets: componentLoader.add('AuctionAssets', './components/auctions/assets'),
  AuctionAssetsCarousel: componentLoader.add(
    'AuctionAssetsCarousel',
    './components/auctions/assets-carousel'
  ),
  BulkDeleteButton: componentLoader.add(
    'BulkDeleteButton',
    './components/common/bulk-delete-button'
  ),
  CustomCategoryIconEdit: componentLoader.add(
    'CustomCategoryIconEdit',
    './components/categories/custom-icon'
  ),
  CategoryUploadedIcon: componentLoader.add('CategoryUploadedIcon', './components/categories/icon'),
  SendAccountNotificationModal: componentLoader.add(
    'SendAccountNotificationModal',
    './components/accounts/send-notification-modal'
  ),
  DashboardPage: componentLoader.add('DashboardPage', './components/dashboard/index'),
}

export default componentLoader
