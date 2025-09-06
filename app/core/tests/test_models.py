"""
Tests for models.
"""

from decimal import Decimal

from django.test import TestCase
from django.contrib.auth import get_user_model

from core.models import Recipe, Tag

User = get_user_model()


def create_user(email="user@example.com", password="test12345"):
    return User.objects.create_user(email, password)


class ModelTests(TestCase):
    """
    Test models.
    """

    def test_create_user_with_email_successful(self):
        """
        Test creating a user with email is successful.
        """
        email = "test@example.com"
        password = "testpass123"
        user = User.objects.create_user(
            email=email,
            password=password,
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """
        Test email is normalized for new users.
        """
        sample_emails = [
            ["test1@EXAMPLE.com", "test1@example.com"],
            ["Test2@example.com", "test2@example.com"],
            ["Test3@example.COM", "test3@example.com"],
        ]

        for email, expected in sample_emails:
            user = User.objects.create_user(email, "sample123")
            self.assertEqual(user.email, expected)

    def test_new_user_without_email_raises_error(self):
        """
        Test creating a user without an email raises an error
        """

        with self.assertRaises(ValueError):
            User.objects.create_user("", "sample123")

    def test_create_superuser(self):
        """
        Test creating a superuser
        """

        user = User.objects.create_superuser("admin@example.com", "sample123")
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)

    def test_create_recipe(self):
        """
        Test creating a recipe is successful.
        """

        user = User.objects.create_user(
            email="test@example.com",
            password="testpass123",
        )

        recipe = Recipe.objects.create(
            user=user,
            title="Sample Recipe Name",
            time_minutes=5,
            price=Decimal("5.50"),
            description="Sample recipe description",
        )

        self.assertEqual(str(recipe), recipe.title)

    def test_create_tag(self):
        """
        Test creating a tag is successful
        """

        user = create_user()
        tag = Tag.objects.create(user=user, name="Tags")

        self.assertEqual(str(tag), tag.name)
