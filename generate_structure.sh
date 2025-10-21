#!/bin/bash

# Thexeason MVP - Folder Structure Generator
# This script creates the complete lib/ and test/ folder structure
# Usage: chmod +x generate_structure.sh && ./generate_structure.sh

echo "🚀 Creating Thexeason MVP folder structure..."
echo ""

# Navigate to project root (assuming script is in project root)
PROJECT_ROOT="$(pwd)"

# Create lib/ folder structure
echo "📁 Creating lib/ folder structure..."

# Main files
touch lib/main.dart
touch lib/app.dart

# Core
mkdir -p lib/core/{constants,config,theme,extensions,utils,errors,network,security}

# Core - Constants
touch lib/core/constants/app_constants.dart
touch lib/core/constants/storage_keys.dart
touch lib/core/constants/route_constants.dart
touch lib/core/constants/regex_constants.dart

# Core - Config
touch lib/core/config/environment_config.dart
touch lib/core/config/firebase_config.dart
touch lib/core/config/api_config.dart

# Core - Theme
touch lib/core/theme/app_theme.dart
touch lib/core/theme/app_colors.dart
touch lib/core/theme/app_typography.dart
touch lib/core/theme/app_spacing.dart
touch lib/core/theme/app_shadows.dart
touch lib/core/theme/app_dimensions.dart

# Core - Extensions
touch lib/core/extensions/context_extensions.dart
touch lib/core/extensions/string_extensions.dart
touch lib/core/extensions/datetime_extensions.dart
touch lib/core/extensions/list_extensions.dart
touch lib/core/extensions/widget_extensions.dart

# Core - Utils
touch lib/core/utils/logger.dart
touch lib/core/utils/validators.dart
touch lib/core/utils/formatters.dart
touch lib/core/utils/compressor.dart
touch lib/core/utils/permission_handler.dart
touch lib/core/utils/connectivity_checker.dart
touch lib/core/utils/debouncer.dart
touch lib/core/utils/crypto_helper.dart

# Core - Errors
touch lib/core/errors/failures.dart
touch lib/core/errors/exceptions.dart
touch lib/core/errors/error_messages.dart

# Core - Network
touch lib/core/network/dio_client.dart
touch lib/core/network/api_interceptor.dart
touch lib/core/network/retry_interceptor.dart
touch lib/core/network/network_info.dart

# Core - Security
touch lib/core/security/encryption_service.dart
touch lib/core/security/secure_storage.dart
touch lib/core/security/token_manager.dart
touch lib/core/security/certificate_pinning.dart

# Data Layer
echo "📦 Creating data/ folder structure..."

mkdir -p lib/data/datasources/local/{boxes,adapters}
mkdir -p lib/data/datasources/remote/{firebase,rest_api,cloudinary,base}
mkdir -p lib/data/{models,repositories}

# Data - Local Datasources
touch lib/data/datasources/local/hive_datasource.dart
touch lib/data/datasources/local/cache_manager.dart

# Data - Local Boxes
touch lib/data/datasources/local/boxes/post_box.dart
touch lib/data/datasources/local/boxes/user_box.dart
touch lib/data/datasources/local/boxes/comment_box.dart
touch lib/data/datasources/local/boxes/draft_box.dart
touch lib/data/datasources/local/boxes/settings_box.dart
touch lib/data/datasources/local/boxes/sync_queue_box.dart

# Data - Local Adapters
touch lib/data/datasources/local/adapters/post_adapter.dart
touch lib/data/datasources/local/adapters/user_adapter.dart
touch lib/data/datasources/local/adapters/comment_adapter.dart
touch lib/data/datasources/local/adapters/media_adapter.dart

# Data - Remote Firebase
touch lib/data/datasources/remote/firebase/auth_datasource.dart
touch lib/data/datasources/remote/firebase/firestore_datasource.dart
touch lib/data/datasources/remote/firebase/storage_datasource.dart
touch lib/data/datasources/remote/firebase/fcm_datasource.dart
touch lib/data/datasources/remote/firebase/firebase_service.dart

# Data - Remote REST API
touch lib/data/datasources/remote/rest_api/auth_api.dart
touch lib/data/datasources/remote/rest_api/posts_api.dart
touch lib/data/datasources/remote/rest_api/users_api.dart
touch lib/data/datasources/remote/rest_api/messages_api.dart

# Data - Remote Cloudinary
touch lib/data/datasources/remote/cloudinary/cloudinary_service.dart
touch lib/data/datasources/remote/cloudinary/cloudinary_config.dart

# Data - Remote Base (Interfaces)
touch lib/data/datasources/remote/base/auth_remote_datasource.dart
touch lib/data/datasources/remote/base/posts_remote_datasource.dart
touch lib/data/datasources/remote/base/users_remote_datasource.dart
touch lib/data/datasources/remote/base/storage_remote_datasource.dart

# Data - Models
touch lib/data/models/user_model.dart
touch lib/data/models/post_model.dart
touch lib/data/models/comment_model.dart
touch lib/data/models/message_model.dart
touch lib/data/models/notification_model.dart
touch lib/data/models/conversation_model.dart
touch lib/data/models/thread_model.dart
touch lib/data/models/media_model.dart
touch lib/data/models/pagination_model.dart

# Data - Repositories
touch lib/data/repositories/auth_repository_impl.dart
touch lib/data/repositories/user_repository_impl.dart
touch lib/data/repositories/post_repository_impl.dart
touch lib/data/repositories/comment_repository_impl.dart
touch lib/data/repositories/message_repository_impl.dart
touch lib/data/repositories/notification_repository_impl.dart
touch lib/data/repositories/storage_repository_impl.dart

# Domain Layer
echo "🧠 Creating domain/ folder structure..."

mkdir -p lib/domain/{entities,repositories}
mkdir -p lib/domain/usecases/{auth,posts,comments,users,messages,notifications}

# Domain - Entities
touch lib/domain/entities/user.dart
touch lib/domain/entities/post.dart
touch lib/domain/entities/comment.dart
touch lib/domain/entities/message.dart
touch lib/domain/entities/notification.dart
touch lib/domain/entities/conversation.dart
touch lib/domain/entities/thread.dart
touch lib/domain/entities/media.dart

# Domain - Repositories (Interfaces)
touch lib/domain/repositories/auth_repository.dart
touch lib/domain/repositories/user_repository.dart
touch lib/domain/repositories/post_repository.dart
touch lib/domain/repositories/comment_repository.dart
touch lib/domain/repositories/message_repository.dart
touch lib/domain/repositories/notification_repository.dart
touch lib/domain/repositories/storage_repository.dart

# Domain - UseCases - Auth
touch lib/domain/usecases/auth/sign_up_usecase.dart
touch lib/domain/usecases/auth/login_usecase.dart
touch lib/domain/usecases/auth/logout_usecase.dart
touch lib/domain/usecases/auth/reset_password_usecase.dart
touch lib/domain/usecases/auth/verify_email_usecase.dart
touch lib/domain/usecases/auth/get_current_user_usecase.dart

# Domain - UseCases - Posts
touch lib/domain/usecases/posts/get_feed_posts_usecase.dart
touch lib/domain/usecases/posts/create_post_usecase.dart
touch lib/domain/usecases/posts/delete_post_usecase.dart
touch lib/domain/usecases/posts/like_post_usecase.dart
touch lib/domain/usecases/posts/unlike_post_usecase.dart
touch lib/domain/usecases/posts/get_post_details_usecase.dart

# Domain - UseCases - Comments
touch lib/domain/usecases/comments/get_comments_usecase.dart
touch lib/domain/usecases/comments/add_comment_usecase.dart
touch lib/domain/usecases/comments/delete_comment_usecase.dart
touch lib/domain/usecases/comments/like_comment_usecase.dart

# Domain - UseCases - Users
touch lib/domain/usecases/users/get_user_profile_usecase.dart
touch lib/domain/usecases/users/update_profile_usecase.dart
touch lib/domain/usecases/users/follow_user_usecase.dart
touch lib/domain/usecases/users/unfollow_user_usecase.dart
touch lib/domain/usecases/users/upload_avatar_usecase.dart

# Domain - UseCases - Messages
touch lib/domain/usecases/messages/get_conversations_usecase.dart
touch lib/domain/usecases/messages/get_messages_usecase.dart
touch lib/domain/usecases/messages/send_message_usecase.dart
touch lib/domain/usecases/messages/delete_message_usecase.dart
touch lib/domain/usecases/messages/mark_as_read_usecase.dart

# Domain - UseCases - Notifications
touch lib/domain/usecases/notifications/get_notifications_usecase.dart
touch lib/domain/usecases/notifications/mark_notification_read_usecase.dart
touch lib/domain/usecases/notifications/clear_all_notifications_usecase.dart

# Presentation Layer
echo "🎨 Creating presentation/ folder structure..."

mkdir -p lib/presentation/{routes,providers}
mkdir -p lib/presentation/features/{auth,feed,composer,profile,comments,messages,shorts,notifications,settings,threads}/{pages,widgets,providers}

# Presentation - Routes
touch lib/presentation/routes/app_router.dart
touch lib/presentation/routes/route_guards.dart
touch lib/presentation/routes/route_transitions.dart

# Presentation - Global Providers
touch lib/presentation/providers/auth_provider.dart
touch lib/presentation/providers/theme_provider.dart
touch lib/presentation/providers/connectivity_provider.dart
touch lib/presentation/providers/sync_provider.dart

# Presentation - Auth Feature
touch lib/presentation/features/auth/pages/login_page.dart
touch lib/presentation/features/auth/pages/signup_page.dart
touch lib/presentation/features/auth/pages/forgot_password_page.dart
touch lib/presentation/features/auth/pages/verify_email_page.dart
touch lib/presentation/features/auth/widgets/auth_text_field.dart
touch lib/presentation/features/auth/widgets/auth_button.dart
touch lib/presentation/features/auth/widgets/social_login_buttons.dart
touch lib/presentation/features/auth/widgets/password_strength_indicator.dart
touch lib/presentation/features/auth/providers/auth_state_provider.dart
touch lib/presentation/features/auth/providers/auth_form_provider.dart

# Presentation - Feed Feature
touch lib/presentation/features/feed/pages/feed_page.dart
touch lib/presentation/features/feed/pages/post_detail_page.dart
touch lib/presentation/features/feed/widgets/post_card.dart
touch lib/presentation/features/feed/widgets/post_actions.dart
touch lib/presentation/features/feed/widgets/post_header.dart
touch lib/presentation/features/feed/widgets/post_media.dart
touch lib/presentation/features/feed/widgets/like_button.dart
touch lib/presentation/features/feed/widgets/comment_button.dart
touch lib/presentation/features/feed/widgets/share_button.dart
touch lib/presentation/features/feed/widgets/feed_skeleton_loader.dart
touch lib/presentation/features/feed/providers/feed_state_provider.dart
touch lib/presentation/features/feed/providers/feed_pagination_provider.dart
touch lib/presentation/features/feed/providers/post_interaction_provider.dart

# Presentation - Composer Feature
touch lib/presentation/features/composer/pages/post_composer_page.dart
touch lib/presentation/features/composer/widgets/media_picker_button.dart
touch lib/presentation/features/composer/widgets/media_preview_grid.dart
touch lib/presentation/features/composer/widgets/voice_recorder.dart
touch lib/presentation/features/composer/widgets/character_counter.dart
touch lib/presentation/features/composer/widgets/hashtag_suggestions.dart
touch lib/presentation/features/composer/widgets/mention_suggestions.dart
touch lib/presentation/features/composer/providers/composer_state_provider.dart
touch lib/presentation/features/composer/providers/draft_provider.dart
touch lib/presentation/features/composer/providers/upload_progress_provider.dart

# Presentation - Profile Feature
touch lib/presentation/features/profile/pages/profile_page.dart
touch lib/presentation/features/profile/pages/edit_profile_page.dart
touch lib/presentation/features/profile/pages/followers_page.dart
touch lib/presentation/features/profile/pages/following_page.dart
touch lib/presentation/features/profile/widgets/profile_header.dart
touch lib/presentation/features/profile/widgets/profile_stats.dart
touch lib/presentation/features/profile/widgets/follow_button.dart
touch lib/presentation/features/profile/widgets/avatar_widget.dart
touch lib/presentation/features/profile/widgets/bio_widget.dart
touch lib/presentation/features/profile/widgets/profile_tabs.dart
touch lib/presentation/features/profile/widgets/posts_grid.dart
touch lib/presentation/features/profile/providers/profile_state_provider.dart
touch lib/presentation/features/profile/providers/profile_edit_provider.dart

# Presentation - Comments Feature
touch lib/presentation/features/comments/pages/comments_page.dart
touch lib/presentation/features/comments/widgets/comment_card.dart
touch lib/presentation/features/comments/widgets/comment_input.dart
touch lib/presentation/features/comments/widgets/nested_comment_thread.dart
touch lib/presentation/features/comments/widgets/comment_actions.dart
touch lib/presentation/features/comments/providers/comments_state_provider.dart
touch lib/presentation/features/comments/providers/comment_form_provider.dart

# Presentation - Messages Feature
touch lib/presentation/features/messages/pages/conversations_page.dart
touch lib/presentation/features/messages/pages/chat_page.dart
touch lib/presentation/features/messages/pages/new_message_page.dart
touch lib/presentation/features/messages/widgets/conversation_tile.dart
touch lib/presentation/features/messages/widgets/message_bubble.dart
touch lib/presentation/features/messages/widgets/message_input.dart
touch lib/presentation/features/messages/widgets/typing_indicator.dart
touch lib/presentation/features/messages/widgets/read_receipt.dart
touch lib/presentation/features/messages/widgets/chat_app_bar.dart
touch lib/presentation/features/messages/providers/conversations_provider.dart
touch lib/presentation/features/messages/providers/messages_provider.dart
touch lib/presentation/features/messages/providers/typing_provider.dart

# Presentation - Shorts Feature
touch lib/presentation/features/shorts/pages/shorts_page.dart
touch lib/presentation/features/shorts/widgets/short_video_player.dart
touch lib/presentation/features/shorts/widgets/short_actions.dart
touch lib/presentation/features/shorts/widgets/short_info_overlay.dart
touch lib/presentation/features/shorts/widgets/volume_control.dart
touch lib/presentation/features/shorts/providers/shorts_state_provider.dart
touch lib/presentation/features/shorts/providers/video_player_provider.dart

# Presentation - Notifications Feature
touch lib/presentation/features/notifications/pages/notifications_page.dart
touch lib/presentation/features/notifications/widgets/notification_tile.dart
touch lib/presentation/features/notifications/widgets/notification_filter_chips.dart
touch lib/presentation/features/notifications/widgets/notification_empty_state.dart
touch lib/presentation/features/notifications/providers/notifications_provider.dart
touch lib/presentation/features/notifications/providers/notification_filter_provider.dart

# Presentation - Settings Feature
touch lib/presentation/features/settings/pages/settings_page.dart
touch lib/presentation/features/settings/pages/account_settings_page.dart
touch lib/presentation/features/settings/pages/privacy_settings_page.dart
touch lib/presentation/features/settings/pages/notification_settings_page.dart
touch lib/presentation/features/settings/pages/about_page.dart
touch lib/presentation/features/settings/widgets/settings_tile.dart
touch lib/presentation/features/settings/widgets/settings_switch.dart
touch lib/presentation/features/settings/widgets/settings_section.dart
touch lib/presentation/features/settings/providers/settings_provider.dart

# Presentation - Threads Feature
touch lib/presentation/features/threads/pages/threads_page.dart
touch lib/presentation/features/threads/pages/thread_detail_page.dart
touch lib/presentation/features/threads/widgets/thread_card.dart
touch lib/presentation/features/threads/widgets/thread_composer.dart
touch lib/presentation/features/threads/widgets/nested_thread.dart
touch lib/presentation/features/threads/providers/threads_provider.dart

# Shared Layer
echo "♻️ Creating shared/ folder structure..."

mkdir -p lib/shared/widgets/{buttons,inputs,loaders,dialogs,cards,avatars,media,navigation,feedback,empty_states,animations}
mkdir -p lib/shared/{models,mixins}

# Shared - Widgets - Buttons
touch lib/shared/widgets/buttons/primary_button.dart
touch lib/shared/widgets/buttons/secondary_button.dart
touch lib/shared/widgets/buttons/icon_button_custom.dart
touch lib/shared/widgets/buttons/floating_action_button_custom.dart

# Shared - Widgets - Inputs
touch lib/shared/widgets/inputs/text_field_custom.dart
touch lib/shared/widgets/inputs/search_bar_custom.dart
touch lib/shared/widgets/inputs/text_area_custom.dart
touch lib/shared/widgets/inputs/otp_input.dart

# Shared - Widgets - Loaders
touch lib/shared/widgets/loaders/loading_spinner.dart
touch lib/shared/widgets/loaders/skeleton_loader.dart
touch lib/shared/widgets/loaders/shimmer_widget.dart
touch lib/shared/widgets/loaders/progress_indicator_custom.dart

# Shared - Widgets - Dialogs
touch lib/shared/widgets/dialogs/confirmation_dialog.dart
touch lib/shared/widgets/dialogs/error_dialog.dart
touch lib/shared/widgets/dialogs/info_dialog.dart
touch lib/shared/widgets/dialogs/bottom_sheet_custom.dart

# Shared - Widgets - Cards
touch lib/shared/widgets/cards/card_custom.dart
touch lib/shared/widgets/cards/user_card.dart
touch lib/shared/widgets/cards/media_card.dart

# Shared - Widgets - Avatars
touch lib/shared/widgets/avatars/avatar_widget.dart
touch lib/shared/widgets/avatars/avatar_stack.dart
touch lib/shared/widgets/avatars/cached_avatar.dart

# Shared - Widgets - Media
touch lib/shared/widgets/media/image_viewer.dart
touch lib/shared/widgets/media/video_player_widget.dart
touch lib/shared/widgets/media/audio_player_widget.dart
touch lib/shared/widgets/media/media_carousel.dart

# Shared - Widgets - Navigation
touch lib/shared/widgets/navigation/bottom_nav_bar.dart
touch lib/shared/widgets/navigation/app_bar_custom.dart
touch lib/shared/widgets/navigation/tab_bar_custom.dart

# Shared - Widgets - Feedback
touch lib/shared/widgets/feedback/snackbar_custom.dart
touch lib/shared/widgets/feedback/toast_widget.dart
touch lib/shared/widgets/feedback/error_widget_custom.dart

# Shared - Widgets - Empty States
touch lib/shared/widgets/empty_states/empty_feed.dart
touch lib/shared/widgets/empty_states/empty_messages.dart
touch lib/shared/widgets/empty_states/empty_notifications.dart
touch lib/shared/widgets/empty_states/no_internet.dart

# Shared - Widgets - Animations
touch lib/shared/widgets/animations/fade_in_animation.dart
touch lib/shared/widgets/animations/slide_animation.dart
touch lib/shared/widgets/animations/heart_animation.dart
touch lib/shared/widgets/animations/lottie_animation_widget.dart

# Shared - Models
touch lib/shared/models/response_wrapper.dart
touch lib/shared/models/pagination_metadata.dart
touch lib/shared/models/api_error.dart

# Shared - Mixins
touch lib/shared/mixins/validation_mixin.dart
touch lib/shared/mixins/keyboard_mixin.dart
touch lib/shared/mixins/loading_mixin.dart
touch lib/shared/mixins/navigation_mixin.dart

# Test folder structure
echo "🧪 Creating test/ folder structure..."

mkdir -p test/{unit,widget,integration}/{core,features,shared}

# Test - Unit - Core
mkdir -p test/unit/core/{utils,network,security}
touch test/unit/core/utils/validators_test.dart
touch test/unit/core/utils/formatters_test.dart
touch test/unit/core/network/dio_client_test.dart
touch test/unit/core/security/encryption_service_test.dart

# Test - Unit - Features
mkdir -p test/unit/features/{auth,posts,profile,messages}
touch test/unit/features/auth/sign_up_usecase_test.dart
touch test/unit/features/auth/login_usecase_test.dart
touch test/unit/features/posts/get_feed_posts_usecase_test.dart
touch test/unit/features/posts/create_post_usecase_test.dart
touch test/unit/features/profile/follow_user_usecase_test.dart
touch test/unit/features/messages/send_message_usecase_test.dart

# Test - Widget Tests
mkdir -p test/widget/features/{auth,feed,profile}
touch test/widget/features/auth/login_page_test.dart
touch test/widget/features/auth/signup_page_test.dart
touch test/widget/features/feed/post_card_test.dart
touch test/widget/features/profile/profile_header_test.dart

# Test - Integration Tests
touch test/integration/auth_flow_test.dart
touch test/integration/post_creation_flow_test.dart
touch test/integration/messaging_flow_test.dart

echo ""
echo "✅ Folder structure created successfully!"
echo ""
echo "📊 Summary:"
echo "   - lib/ folder: $(find lib -type f | wc -l) files created"
echo "   - test/ folder: $(find test -type f | wc -l) files created"
echo ""
echo "🎯 Next steps:"
echo "   1. Run 'flutter pub get' to install dependencies"
echo "   2. Start implementing core infrastructure (theme, constants)"
echo "   3. Set up Firebase configuration"
echo "   4. Initialize Hive with boxes"
echo ""
echo "🚀 Happy coding!"